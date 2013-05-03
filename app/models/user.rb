class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :comment_upvotings, :class_name => "Voting", :foreign_key => "voter_id", 
                                :conditions => { :voteable_type => "Comment", :up_vote => true }

  has_many :comment_downvotings, :class_name => "Voting", :foreign_key => "voter_id", 
                                :conditions => { :voteable_type => "Comment", :up_vote => false }

  has_many :comment_votings, :class_name => "Voting", :foreign_key => "voter_id", 
                                :conditions => { :voteable_type => "Comment"}
  has_many :comments

  # scope :comment_upvotes, where('voteable_type => "Comment",
  #                                       :voter_type => "User",
  #                                       :up_vote => true,
  #                                       :voter_id => ?', self.id)
  make_voter

end
