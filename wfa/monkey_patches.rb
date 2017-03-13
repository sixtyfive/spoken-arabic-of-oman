class Hash
  def compact
    delete_if do |k, v|
      (v.respond_to?(:empty?) ? v.empty? : !v) or v.instance_of?(Hash) && v.compact.empty?
    end
  end
end
