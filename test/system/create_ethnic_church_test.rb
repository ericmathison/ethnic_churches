require 'application_system_test_case'

class CreateEthnicChurchTest < ApplicationSystemTestCase
  setup do
    @church_name = 'Chinese Church of Footown'
    @phone = '1234567890'
    @website = 'https://example.com/'
    @pastors_name = 'John Doe'
    @email = 'foo@example.com'
    @invalid_email = 'foo'
    @existing_language = languages(:chinese).name
    @new_language = 'foolang'
    @country = countries(:china).name
    @religious_background = religious_backgrounds(:protestant).persuasion
    @street = '1234 Foostreet'
    @city = 'Footown'
    @zip = '99999'
    @note = 'This is a note.'
    @admin = admins(:alice)
  end

  test 'successfully creates an ethnic church and associated objects' do
    login_as @admin
    visit new_ethnic_church_path

    #ethnic church
    fill_in 'ethnic_church_name', with: @church_name
    fill_in 'ethnic_church_phone', with: @phone
    fill_in 'ethnic_church_website', with: @website
    fill_in 'ethnic_church_pastors_name', with: @pastors_name
    fill_in 'ethnic_church_email', with: @email

    find('.chosen-search-input').click
    within('.chosen-drop') do
      find('li', text: @existing_language).click
    end
    find('.chosen-search-input').click.send_keys(@new_language)
    click_link 'add_new_language'
    fill_in 'ethnic_church_country_name', with: @country
    fill_in 'ethnic_church_religious_background_persuasion', with: @religious_background

    #address
    fill_in 'ethnic_church_address_street', with: @street
    fill_in 'ethnic_church_address_city', with: @city
    fill_in 'ethnic_church_address_zip', with: @zip

    #note
    fill_in 'ethnic_church_note_content', with: @note

    click_button 'create'

    assert_selector '#church_name', text: @church_name
    assert_selector '#phone', text: @phone
    assert_selector '#website', text: @website
    assert_selector '#pastors_name', text: @pastors_name
    assert_selector '#email', text: @email
    assert_selector '#address', text: @street
    assert_selector '#address', text: @city
    assert_selector '#address', text: @zip
    assert_selector '#language', text: @existing_language
    assert_selector '#language', text: @new_language
    assert_selector '#country', text: @country
    assert_selector '#religious_background', text: @religious_background
    assert_selector '#note', text: @note
    assert_selector '#notice', text: 'Successfully added new Ethnic Church'
  end

  test 'displays error for invalid input' do
    login_as @admin
    visit new_ethnic_church_path
    fill_in 'ethnic_church_email', with: @invalid_email
    click_button 'create'
    assert_selector '#alert', text: 'Email is invalid'
  end

  test 'records are not saved on invalid input' do
    Capybara.current_driver = :rack_test
    login_as @admin

    ec_count_before = EthnicChurch.count
    language_count_before = Language.count
    country_count_before = Country.count
    religious_background_count_before = ReligiousBackground.count
    address_count_before = Address.count

    visit new_ethnic_church_path
    fill_in 'ethnic_church_country_name', with: 'Egypt'
    fill_in 'ethnic_church_religious_background_persuasion', with: 'Coptic'
    fill_in 'ethnic_church_email', with: @invalid_email
    click_button 'create'

    ec_count_after = EthnicChurch.count
    language_count_after = Language.count
    country_count_after = Country.count
    religious_background_count_after = ReligiousBackground.count
    address_count_after = Address.count

    assert_equal ec_count_before, ec_count_after, 'ethnic church count is off'
    assert_equal language_count_before, language_count_after, 'language count is off'
    assert_equal country_count_before, country_count_after, 'country count is off'
    assert_equal religious_background_count_before, religious_background_count_after, 'religious background count is off'
    assert_equal address_count_before, address_count_after, 'address count is off'
  end

  test 'no error for empty email' do
    login_as @admin
    empty_string = ''
    visit new_ethnic_church_path
    fill_in 'ethnic_church_email', with: empty_string
    click_button 'create'
    assert_selector '#notice', text: 'Successfully added new Ethnic Church'
  end
end
