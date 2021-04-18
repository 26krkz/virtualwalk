FactoryBot.define do
  factory :video do
    video_id { SecureRandom.alphanumeric(9) }
    region { 'Asia' }
    country { 'Japan'}
    tag1 { 'videos_tag1' }
    time { '1:00:00' }
  end
end
