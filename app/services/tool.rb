class Tool
  class << self
    def repos_contain_member git, repos, user_name, member_name
      result = []
      list_repos = repos_members git, repos, user_name
      list_repos.each do |repository|
        if repos_has_member? repository[:member], member_name
          result << {"repos": repository[:repos], "html_url": repository[:html_url]}
        end
      end
      result
    end

    def repos_members git, repos, user_name
      result = []
      forks = Tool.list_forks git, repos, user_name
      forks.each do |fork|
        members = Tool.fork_members fork
        result << {"repos": fork[:repos], "html_url": fork[:html_url], "member": members}
      end
      result
    end

    def list_forks git, repos, user_name
      result = []
      repos.each do |repos_name|
        fork = git.repos.forks.list user_name, repos_name[:name]
        if fork.body.present?
          result <<  {"repos": repos_name[:name], "html_url": repos_name[:html_url], "fork": fork}
        end
      end
      result
    end

    def fork_members fork
      result = []
      fork[:fork].body.each do |body|
        login = body[:owner][:login]
        html_url = body[:owner][:html_url]
        result << {"login": login, "html_url": html_url}
      end
      result
    end

    def repos_has_member? repos_members, member_name
      repos_members.each do |member|
        return true if member[:login].include? member_name
      end
      false
    end
  end
end
