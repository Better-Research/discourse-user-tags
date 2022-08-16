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
  add_to_serializer(:topic_view, :tag_owners) do
    puts "Looking for #{object.topic.user.id}"
    puts "topic tags count #{object.topic.tags.count}"
    puts "my tags #{object.topic.user.custom_fields['tags']}"
    user_tag = object.topic.user.custom_fields['tags'] ? object.topic.user.custom_fields['tags'].first : nil
    tags = object.topic.tags.pluck(:name)
    ucf = UserCustomField.where('value in (?)', tags)
    users = []
    ucf.each do |user|
      name = User.find(user.user_id).username
      puts "got the name: #{name}"
      users.append(name)
    end
    puts "here are the users: #{users.first}, #{users.last}"
    puts "got the ucf: #{ucf.first}"
    users.uniq
  end
  add_to_serializer(:user, :user_tags) do
    object.custom_fields['tags']
  end
end
