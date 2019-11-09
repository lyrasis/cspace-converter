require 'uri'

class RemoteActionService
  attr_reader :object, :service

  class Status
    attr_accessor :ok, :message
    def initialize(ok: false, message: '')
      @ok      = ok
      @message = message
    end

    def bad(message)
      @ok      = false
      @message = message
      Rails.logger.error(message)
    end

    def good(message)
      @ok      = true
      @message = message
      Rails.logger.debug(message)
    end
  end

  def initialize(object)
    @object  = object
    @service = Lookup.record_class(object.type).service(object.subtype)
  end

  def list_criteria
    relation  = service[:path] == "relations"
    list_type = relation ? "relations_common_list" : "abstract_common_list"
    list_item = relation ? "relation_list_item" : "list_item"
    [relation, list_type, list_item]
  end

  def self.perform_search_request(path:, schema:, field:, value:)
    search_args = {
      path: path,
      type: schema,
      field: field,
      expression: "= '#{value}'",
    }
    query = CollectionSpace::Search.new.from_hash search_args
    $collectionspace_client.search(query)
  end

  def perform_search_request
    RemoteActionService.perform_search_request(
      path: service[:path],
      schema: "#{service[:schema]}_common",
      field: object.identifier_field,
      value: object.identifier,
    )
  end

  def remote_delete
    status = Status.new
    if object.has_csid_and_uri?
      Rails.logger.debug("Deleting: #{object.identifier}")
      begin
        response = $collectionspace_client.delete(object.uri)
        if response.status_code.to_s =~ /^2/
          object.update_attributes!(csid: nil, uri:  nil)
          status.good "Deleted: #{object.identifier}"
        else
          status.bad "Error response: #{response.body}"
        end
      rescue Exception => ex
        status.bad "Error during delete: #{object.inspect}.\n#{ex.backtrace}"
      end
    else
      status.bad "Delete requires existing csid and uri."
    end
    status
  end

  def remote_transfer
    status = Status.new
    unless object.has_csid_and_uri?
      Rails.logger.debug("Transferring: #{object.identifier}")
      begin
        blob_uri = object.data_object.csv_data.fetch('bloburi', nil)
        blob_uri = URI.encode blob_uri if !blob_uri.blank?
        params   = (blob_uri && object.type == 'Media') ? { query: { 'blobUri' => blob_uri } } : {}
        response = $collectionspace_client.post(service[:path], object.content, params)
        if response.status_code.to_s =~ /^2/
          # http://localhost:1980/cspace-services/collectionobjects/7e5abd18-5aec-4b7f-a10c
          csid = response.headers["Location"].split("/")[-1]
          uri  = "#{service[:path]}/#{csid}"
          object.update_attributes!(csid: csid, uri:  uri)
          status.good "Transferred: #{object.identifier}"
        else
          status.bad "Error response: #{response.body}"
        end
      rescue Exception => ex
        status.bad = "Error during transfer: #{object.inspect}.\n#{ex.backtrace}"
      end
    else
      status.bad "Transfer requires no pre-existing csid and uri."
    end
    status
  end

  def remote_update
    status = Status.new
    if object.has_csid_and_uri?
      Rails.logger.debug("Updating: #{object.identifier}")
      begin
        response = $collectionspace_client.put(object.uri, object.content)
        if response.status_code.to_s =~ /^2/
          status.good "Updated: #{object.identifier}"
        else
          status.bad "Error response: #{response.body}"
        end
      rescue Exception => ex
        status.bad = "Error during update: #{object.inspect}.\n#{ex.backtrace}"
      end
    else
      status.bad "Update requires existing csid and uri."
    end
    status
  end

  def remote_ping
    status = Status.new
    message_string = "#{service[:path]} #{service[:schema]} #{object.identifier_field} #{object.identifier}"
    response = perform_search_request

    unless response.status_code.to_s =~ /^2/
      status.bad "Error searching #{message_string}"
      return status
    end
    parsed_response = response.parsed
    relation, list_type, list_item = list_criteria
    return status if relation # cannot reliably interpret search on relations

    result_count = parsed_response[list_type]["totalItems"].to_i
    if result_count == 0
      object.update_attributes!(csid: nil, uri: nil)
      status.good 'Record was not found.'
    elsif result_count == 1
      object.update_attributes!(
        csid: parsed_response[list_type][list_item]["csid"],
        uri:  parsed_response[list_type][list_item]["uri"].gsub(/^\//, '')
      )
      status.good 'Record was found.'
    else
      status.bad "Ambiguous result count (#{result_count}) for #{message_string}"
    end
    status
  end
end
