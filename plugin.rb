# frozen_string_literal: true

# name: discourse-user-tag
# about: Add tag as user_custom_field and add to topic serializer
# version: 0.0.1
# authors: Jay Pfaffman
# url: https://github.com/literatecomputing/discourse-user-tags
# required_version: 2.7.0

enabled_site_setting :user_tag_enabled

after_initialize do
  register_editable_user_custom_field(tags, staff_only: true)
  allow_public_user_custom_field(tags)
end
