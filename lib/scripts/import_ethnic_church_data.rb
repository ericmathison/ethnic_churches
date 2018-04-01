require 'csv'

headers = %i[street city country website language name notes pastors_name phone religious_background state zip]

CSV.foreach(ARGV[0], headers: headers) do |csv|
  printf "\rProcessing line: %s", $INPUT_LINE_NUMBER

  hash = csv.to_h.transform_values(&:strip).transform_values { |value| value if value.present? }

  ethnic_church = hash.slice(:name, :phone, :website, :pastors_name)
  language_name = hash[:language]
  country = hash.slice(:country)
  religious_background = hash.slice(:religious_background)
  notes = hash.slice(:notes)
  address = hash.slice(:street, :city, :state, :zip)

  EthnicChurch.transaction do
    country = Country.find_or_initialize_by(name: country[:country])
    religious_background = ReligiousBackground.find_or_initialize_by(persuasion: religious_background[:religious_background])

    ethnic_church = EthnicChurch.new(ethnic_church)

    ethnic_church.languages = [language_name]
    ethnic_church.country = country
    ethnic_church.religious_background = religious_background
    ethnic_church.build_note(content: notes[:notes])
    ethnic_church.build_address(address)
    ethnic_church.save!
  end
end
puts
