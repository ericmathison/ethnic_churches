require "application_system_test_case"

class CreateTest < ApplicationSystemTestCase
  test 'successfully creates an ethnic church and associated objects' do
    visit new_ethnic_church_path

    church_name = 'Chinese Church of Footown'
    phone = '1234567890'
    website = 'https://example.com/'
    pastors_name = 'John Doe'
    email = 'foo@example.com'

    #use existing language to ensure application can handle re-using
    #language names
    language = languages(:chinese).name

    #use a language that does not exist in the database
    language2 = 'foolang'

    #use an existing country name
    country = countries(:china).name

    #use an existing religious_background name
    religious_background = religious_backgrounds(:protestant).persuasion

    street = '1234 Foostreet'
    city = 'Footown'
    zip = '99999'
    note = 'This is a note.'

    #ethnic church
    fill_in 'ethnic_church_name', with: church_name
    fill_in 'ethnic_church_phone', with: phone
    fill_in 'ethnic_church_website', with: website
    fill_in 'ethnic_church_pastors_name', with: pastors_name
    fill_in 'ethnic_church_email', with: email

    find('.chosen-search-input').click
    within('.chosen-drop') do
      find('li', text: language).click
    end
    find('.chosen-search-input').click.send_keys(language2)
    click_link 'add_new_language'
    fill_in 'country_name', with: country
    fill_in 'religious_background_persuasion', with: religious_background

    #address
    fill_in 'address_street', with: street
    fill_in 'address_city', with: city
    fill_in 'address_zip', with: zip

    #note
    fill_in 'note_content', with: note

    click_button 'create'

    assert_selector '#church_name', { text: church_name }
    assert_selector '#phone', { text: phone }
    assert_selector '#website', { text: website }
    assert_selector '#pastors_name', { text: pastors_name }
    assert_selector '#email', { text: email }
    assert_selector '#address', { text: street }
    assert_selector '#address', { text: city }
    assert_selector '#address', { text: zip }
    assert_selector '#language', { text: language }
    assert_selector '#language', { text: language2 }
    assert_selector '#country', { text: country }
    assert_selector '#religious_background', { text: religious_background }
    assert_selector '#notice', { text: 'Successfully added new Ethnic Church' }
  end
end
