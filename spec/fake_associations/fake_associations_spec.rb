require 'spec_helper'

describe FakeAssociations do
  class User
    include ActiveModel::Model
    include FakeAssociations

    attr_accessor :id

    has_many :posts
    has_many :favorites
    has_many :friendships, foreign_key: 'follower_id'
    has_many :followed_users, through: :friendships, source: :followed
    has_many :reverse_friendships, foreign_key: 'followed_id', class_name: 'Friendship'
    has_many :followers, through: :reverse_friendships, source: :follower

    has_many :favorites_posts, through: :favorites, source: :post
  end

  describe 'has_many' do
    it 'Add has_many method' do
      expect(User).to be_respond_to(:has_many)
    end

    describe '.has_many' do
      let(:user) { User.new(id: 1) }

      it 'defines association' do
        expect(user).to be_respond_to(:posts)
      end

      describe 'association' do
        let!(:post) { Post.create(user_id: user.id) }

        context 'target post model' do
          it 'returns posts object' do
            expect(user.posts).to eq [post]
          end

          context 'through favorite model' do
            context 'using through and source options' do
              it 'defines association' do
                expect(user).to be_respond_to(:favorites_posts)
              end

              describe 'association' do
                let!(:favorites) do
                  Favorite.create(user_id: user.id, post_id: post.id)
                end

                it 'returns favorite posts object' do
                  expect(user.favorites_posts).to eq [post]
                end
              end
            end
          end
        end

        context 'target user model' do
          let(:other_user) { User.new(id: 2) }
          before do
            Friendship.create(follower_id: user.id, followed_id: other_user.id)
            Friendship.create(follower_id: other_user.id, followed_id: user.id)
          end

          context 'through friendship model' do
            context 'using foreign_key option in through' do
              it 'defines association' do
                expect(user).to be_respond_to(:followed_users)
              end

              describe 'association' do
                it 'returns followed users object' do
                  expect(
                    user.followed_users.map(&:id)).to eq [other_user].map(&:id)
                end
              end
            end

            context 'using foreign_key and class_name options in through' do
              it 'defines association' do
                expect(user).to be_respond_to(:followers)
              end

              describe 'association' do
                it 'returns followed users object' do
                  expect(user.followers.map(&:id)).to eq [other_user].map(&:id)
                end
              end
            end
          end
        end
      end
    end
  end
end
