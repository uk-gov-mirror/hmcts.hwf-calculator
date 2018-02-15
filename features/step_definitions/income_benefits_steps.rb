Given(/^I am on the income benefits page$/) do
  answer_up_to(:benefits)
end

Then(/^I should see that I should be able to get help with fees message$/) do
  expect(any_calculator_page.positive_message).to be_present
end

Then(/^I should see income benefits list$/) do
  expect(income_benefits_page.benefit_options).to be_present
end

When(/^I select none of the above$/) do
  income_benefits_page.choose :none
end

When(/^I answer the income benefits question$/) do
  answer_benefits_question
end

Then(/^I should see the none of the above guidance information$/) do
  expect(income_benefits_page.none_of_the_above_guidance).to be_present
end

When(/^I select dont know$/) do
  income_benefits_page.choose :dont_know
end

Then(/^I should see the dont know guidance information$/) do
  expect(income_benefits_page.dont_know_guidance).to be_present
end

When(/^I submit the page with income related benefit checked$/) do
  income_benefits_page.choose :jobseekers_allowance
  income_benefits_page.next
end

Then(/^I should see that I should be eligible for a full remission$/) do
  expect(full_remission_page).to be_displayed
end

When(/^I click next without submitting my income benefits$/) do
  income_benefits_page.next
end

Then(/^I should see the income benefits error message$/) do
  expect(income_benefits_page.benefits).to have_error_nothing_selected
end

When(/^I successfully submit my income benefits$/) do
  income_benefits_page.choose :jobseekers_allowance
  income_benefits_page.choose :income_support
  income_benefits_page.next
end

Then(/^on the next page my income benefit has been added to previous answers$/) do
  expect(full_remission_page.previous_answers.marital_status).to have_answered(user.marital_status)
  expect(full_remission_page.previous_answers.court_fee).to have_answered(user.fee)
  expect(full_remission_page.previous_answers.date_of_birth).to have_answered(user.date_of_birth)
  expect(full_remission_page.previous_answers.disposable_capital).to have_answered(user.disposable_capital)
  expect(full_remission_page.previous_answers.income_benefits).to have_answered(user.income_benefits)
end

When(/^I click on how benefits affect your claim$/) do
  income_benefits_page.toggle_guidance
end

Then(/^I should see the copy for how benefits affect your claim$/) do
  expect(income_benefits_page.validate_guidance).to be true
end
