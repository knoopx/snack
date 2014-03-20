class Classifier
  # The class can be created with one or more categories, each of which will be
  # initialized and given a training method. E.g.,
  #      b = Classifier::Bayes.new :categories => ['Interesting', 'Uninteresting', 'Spam']
  #  you can specify language and encoding parameters for stemmer
  # (default values - :language => 'en', :encoding => 'UTF_8')
  #      b = Classifier::Bayes.new :categories => ['Interesting', 'Uninteresting', 'Spam'], :language => 'ru'
  def initialize(options = {})
    @categories = Hash.new
    options.reverse_merge!(:categories => [])
    options[:categories].each { |category| @categories[prepare_category_name(category)] = Hash.new }
    @total_words = 0
    super
  end

  #
  # Provides a general training method for all categories specified in Bayes#new
  # For example:
  #     b = Classifier::Bayes.new 'This', 'That', 'the_other'
  #     b.train :this, "This text"
  #     b.train "that", "That text"
  #     b.train "The other", "The other text"
  def train(category, text)
    category = prepare_category_name(category)
    word_hash(text).each do |word, count|
      @categories[category][word] ||= 0
      @categories[category][word] += count
      @total_words += count
    end
  end

  #
  # Provides a untraining method for all categories specified in Bayes#new
  # Be very careful with this method.
  #
  # For example:
  #     b = Classifier::Bayes.new 'This', 'That', 'the_other'
  #     b.train :this, "This text"
  #     b.untrain :this, "This text"
  def untrain(category, text)
    category = prepare_category_name(category)
    word_hash(text).each do |word, count|
      if @total_words >= 0
        orig = @categories[category][word] || 0
        @categories[category][word] ||= 0
        @categories[category][word] -= count
        if @categories[category][word] <= 0
          @categories[category].delete(word)
          count = orig
        end
        @total_words -= count
      end
    end
  end

  #
  # Returns the scores in each category the provided +text+. E.g.,
  #    b.classifications "I hate bad words and you"
  #    =>  {"Uninteresting"=>-12.6997928013932, "Interesting"=>-18.4206807439524}
  # The largest of these scores (the one closest to 0) is the one picked out by #classify
  def classifications(text)
    score = Hash.new
    @categories.each do |category, category_words|
      score[category.to_s] = 0
      total = category_words.values.sum
      word_hash(text).each do |word, count|
        s = category_words.has_key?(word) ? category_words[word] : 0.1
        score[category.to_s] += Math.log(s/total.to_f)
      end
    end
    return score
  end

  #
  # Returns the classification of the provided +text+, which is one of the
  # categories given in the initializer. E.g.,
  #    b.classify "I hate bad words and you"
  #    =>  'Uninteresting'
  def classify(text)
    (classifications(text).sort_by { |a| -a[1] })[0][0]
  end

  #
  # Provides a list of category names
  # For example:
  #     b.categories
  #     =>   ['This', 'That', 'the_other']
  def categories # :nodoc:
    @categories.keys.collect { |c| c.to_s }
  end

  #
  # Allows you to add categories to the classifier.
  # For example:
  #     b.add_category "Not spam"
  #
  # WARNING: Adding categories to a trained classifier will
  # result in an undertrained category that will tend to match
  # more criteria than the trained selective categories. In short,
  # try to initialize your categories at initialization.
  def add_category(category)
    @categories[prepare_category_name(category)] = Hash.new
  end


  # Removes common punctuation symbols, returning a new string.
  # E.g.,
  #   "Hello (greeting's), with {braces} < >...?".without_punctuation
  #   => "Hello  greetings   with  braces         "
  def without_punctuation str
    str.tr(',?.!;:"@#$%^&*()_=+[]{}\|<>/`~', " ").tr("'\-", "")
  end

  # Return a Hash of strings => ints. Each word in the string is stemmed,
  # and indexes to its frequency in the document.
  def word_hash str
    word_hash_for_words(str.gsub(/[^\w\s]/, "").split + str.gsub(/[\w]/, " ").split)
  end

  # Return a word hash without extra punctuation or short symbols, just stemmed words
  def clean_word_hash str
    word_hash_for_words str.gsub(/[^\w\s]/, "").split
  end

  def word_hash_for_words(words)
    hash = {}
    skip_words = []
    words.each do |word|
      word = word.mb_chars.downcase.to_s if word =~ /[\w]+/
      key = stemmer.stem(word)
      if word =~ /[^\w]/ || !skip_words.include?(word) && word.length > 2
        hash[key] ||= 0
        hash[key] += 1
      end
    end
    hash
  end
end
