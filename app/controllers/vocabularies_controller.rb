# coding: utf-8

class VocabulariesController < ApplicationController

  # GET /vocabularies
  def index
    @vocabularies = Vocabulary.all
  end

  # GET /vocabularies/new
  def new
  end

  # POST /vocabularies/create
  def create
    vocabulary = Vocabulary.new(vocabulary_name: params[:vocabulary_name])
    if vocabulary.save
      params[:words].split("\r\n").each do |word|
        vocabulary.vocabulary_words.create(
          word_ja: word.split(',')[0].strip,
          word_en: word.split(',')[1].strip
        )
      end
      redirect_to '/vocabularies'
    else
      render :new
    end
  end

  # GET /vocabularies/:vocabulary_id/quiz
  def quiz
    @vocabulary = Vocabulary.find(params[:vocabulary_id])
  end

  # GET /vocabularies/:vocabulary_id/quizzes.json
  def quizzes
    if Rails.env == 'production'
      words = VocabularyWord.where(vocabulary_id: params[:vocabulary_id]).order('RAND()').limit(30)
    else
      words = VocabularyWord.where(vocabulary_id: params[:vocabulary_id]).order('RANDOM()').limit(30)
    end
    quizzes = Array.new
    words.each do |word|
      if rand < 0.5
        quizzes << { question: word.word_ja, answer: word.word_en }
      else
        quizzes << { question: word.word_en, answer: word.word_ja }
      end
    end
    render json: { quizzes: quizzes, count: quizzes.count }
  end

  # GET /vocabularies/:vocabulary_id/:vocabulary_name.csv
  def send_csv
    send_data "\xEF\xBB\xBF" + Vocabulary.find(params[:vocabulary_id]).vocabulary_words.to_a.map {|w| "#{w.word_ja},#{w.word_en}"}.join("\r\n"), filename: "#{params[:vocabulary_name]}.csv", content_type: 'application/octet-stream'
  end
end
