require 'twitter'
require 'json'

if rand > 0.5
  abort 'not sending'
end

twitter_conf = File.open('./twitter_credentials.json') { |f|
  JSON.parse(f.read)
}
secciones = File.open('./data.json') { |f|
  JSON.parse(f.read)
}
already_sent = File.open('./already_sent.json') { |f|
  JSON.parse(f.read)
} rescue []


client = Twitter::REST::Client.new do |config|
  config.consumer_key        = twitter_conf['consumer_key']
  config.consumer_secret     = twitter_conf['consumer_secret']
  config.access_token        = twitter_conf['access_token']
  config.access_token_secret = twitter_conf['access_token_secret']
end


short_url_length = client.configuration[:short_url_length]

sentences = secciones.map { |k, v| v['sentences'] }.flatten

# encontrar oraciones candidatas
# largo menor a 140 - largo_url - 1
c = sentences.select { |s|
  already_sent.find { |sent| sent['sentence'] == s }.nil? \
  && s.length.between?(5, 140 - (short_url_length + 1))
}

candidate_sentence = c.sample
candidate_sentence_idx = sentences.index(candidate_sentence)

status_msg = "#{candidate_sentence} http://urbeinvisible.nerdpower.org/#s_#{candidate_sentence_idx}"

client.update(status_msg)

already_sent << { 'date' => Time.now.to_f, 'sentence' => candidate_sentence }

File.open('./already_sent.json', 'w') { |f|
  JSON.dump(already_sent, f)
}
