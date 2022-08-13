# frozen_string_literal: true

# name: discourse-user-tag
# about: Add tag as user_custom_field and add to topic serializer
# version: 0.0.1
# authors: Jay Pfaffman
# url: https://github.com/literatecomputing/discourse-user-tags
# required_version: 2.7.0

enabled_site_setting :user_tags_enabled

after_initialize do
  register_editable_user_custom_field(:tags, staff_only: false)
  register_user_custom_field_type(:tags, 'list')
  allow_public_user_custom_field(:tags)
  DiscoursePluginRegistry.serialized_current_user_fields << 'tags'
  add_to_serializer(:topic_view, :user_tags) do
    object.topic.user.custom_fields['tags']
  end
  add_to_serializer(:user, :user_tags) do
    object.custom_fields['tags']
  end
end
