require 'rails_helper'

RSpec.describe 'Post' do

  describe 'GET /api/posts' do
    it 'lists posts' do
      post = Post.create!(title: 'Foo', tags: [Tag.new(name: 'bar')])

      get api_posts_path(format: 'json')
      expect(response).to be_successful

      json = JSON.parse(response.body)
      expect(json).to be_a(Array)
      expect(json[0]['title']).to eq(post.title)
      expect(json[0]['tags'].count).to eq(post.tags.count)
      expect(json[0]['tags'].first['name']).to eq(post.tags.first.name)
    end
  end

  describe 'GET /api/posts/search' do
    it '422 - should return unprocesseable entity if query param "term" is missing' do
      get '/api/posts/search', as: :json

      json = JSON.parse(response.body)
      expect(response.status).to eq(422)
      expect(json["error"]).to eq("Missing 'term' parameter")
    end

    it '200 - should return all the items that contains `term` in their titles' do
      post_1 = Post.create!(title: 'Title with the term foo', tags: [Tag.new(name: 'tag1')])
      post_2 = Post.create!(title: 'Another title with the term foo', tags: [Tag.new(name: 'tag2')])

      post_3 = Post.create!(title: 'Title with the term bar', tags: [Tag.new(name: 'tag2')])
    
      get '/api/posts/search', params: { term: 'foo' }, as: :json
      expect(response).to be_successful

      json = JSON.parse(response.body)
      expect(json).to be_a(Array)
      expect(json.length).to eq(2)
      expect(json.map { |post| post['title'] }).to include(post_1.title, post_2.title)
    end

    it '200 - should return all the items that have at least one tag equal to `term`' do
      post_1 = Post.create!(title: 'Title with the term foo', tags: [Tag.new(name: 'tag1')])
      post_2 = Post.create!(title: 'Another title with the term foo', tags: [Tag.new(name: 'tag2')])
      post_3 = Post.create!(title: 'Title with the term bar', tags: [Tag.new(name: 'tag2')])
    
      get '/api/posts/search', params: { term: 'tag2' }, as: :json
      expect(response).to be_successful

      json = JSON.parse(response.body)
      expect(json).to be_a(Array)
      expect(json.length).to eq(2)
      expect(json.map { |post| post['title'] }).to include(post_2.title, post_3.title)
    end

    it '200 - should not include partial part of the tag name' do
      post_1 = Post.create!(title: 'Title with the term foo', tags: [Tag.new(name: 'tag1')])
      post_2 = Post.create!(title: 'Another title with the term foo', tags: [Tag.new(name: 'tag2')])
      post_3 = Post.create!(title: 'Title with the term bar', tags: [Tag.new(name: 'tag2')])
    
      get '/api/posts/search', params: { term: 'tag' }, as: :json
      expect(response).to be_successful

      json = JSON.parse(response.body)
      expect(json).to be_a(Array)
      expect(json.length).to eq(0)
    end

    it '200 - should not return duplicated items' do
      post_1 = Post.create!(title: 'Title with the term foo', tags: [Tag.new(name: 'foo')])
      post_2 = Post.create!(title: 'Another title with the term foo', tags: [Tag.new(name: 'tag2')])
      post_3 = Post.create!(title: 'Title with the term bar', tags: [Tag.new(name: 'foo')])
    
      get '/api/posts/search', params: { term: 'foo' }, as: :json
      expect(response).to be_successful

      json = JSON.parse(response.body)
      expect(json).to be_a(Array)
      expect(json.length).to eq(3)
      expect(json.map { |post| post['title'] }).to include(post_1.title, post_2.title, post_3.title)
    end
  end
end
