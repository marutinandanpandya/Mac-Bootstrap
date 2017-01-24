
module JIRA
  module Resource
    class Issue < JIRA::Base
      def worklogs
        return worklog unless @attrs and @attrs['fields'] and @attrs['fields']['worklog'] and
                              @attrs['fields']['worklog']['total'] > @attrs['fields']['worklog']['maxResults']

        url = client.options[:rest_base_path] + "/#{self.class.endpoint_name}/#{id}/worklog"

        response = client.get(url)
        set_attrs({'fields' => { 'worklog' => self.class.parse_json(response.body) }}, false)
      end
    end

  end
end
