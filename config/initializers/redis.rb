db = { 'development' => 0, 'test' => 0, 'production' => 2 }[Rails.env]
$redis = Redis::Namespace.new("sm2_#{Rails.env}", redis: Redis.new(db: db))
