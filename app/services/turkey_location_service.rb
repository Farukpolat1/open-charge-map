class TurkeyLocationService
  def self.provinces
    TURKEY_PROVINCES_DATA.keys
  end

  def self.districts_for(il)
    TURKEY_PROVINCES_DATA[il]
  end

  def self.match(address_line)
    return nil if address_line.blank?

    il, ilceler = TURKEY_PROVINCES_DATA.find { |il, ilceler| ilceler.any? { |ilce| address_line.include?(ilce) } }
    return nil unless il

    eslesen_ilce = ilceler.find { |ilce| address_line.include?(ilce) }
    { il: il, ilce: eslesen_ilce }
  end
end
