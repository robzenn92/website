module Dynamic
  module Utils
    def front_matter(file)
      if has_yaml_header?(file)
        YAML.load_file(file)
      else
        {}
      end
    end

    def has_yaml_header?(file)
      !!(File.open(file, 'rb') { |f| f.read(5) } =~ /\A---\r?\n/)
    end

    # Lifted from
    # http://gemjack.com/gems/tartan-0.1.1/classes/Hash.html
    #
    # Thanks to whoever made it.
    def deep_merge_hashes(master_hash, other_hash)
      target = master_hash.dup

      other_hash.each_key do |key|
        if other_hash[key].is_a? Hash and target[key].is_a? Hash
          target[key] = deep_merge_hashes(target[key], other_hash[key])
          next
        end

        target[key] = other_hash[key]
      end

      target
    end

  end
end
