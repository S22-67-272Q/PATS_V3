class User < ApplicationRecord
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods

  # Use built-in rails support for password protection
  has_secure_password
    
  # Relationships
  # has_many :notes
  has_one :owner

  # Validations
  # make sure required fields are present
  validates_presence_of :first_name, :last_name 
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates_presence_of :password, :on => :create 
  validates_presence_of :password_confirmation, :on => :create 
  validates_confirmation_of :password, message: "does not match"
  validates_length_of :password, :minimum => 4, message: "must be at least 4 characters long", :allow_blank => true
  validates_inclusion_of :role, in: %w( vet assistant owner ), message: "is not recognized in the system"
  
  # Other methods
  # -----------------------------  
  def proper_name
    first_name + " " + last_name
  end
  
  def name
    last_name + ", " + first_name
  end

  # We have this role? method here. 
  # We defined it on our own here in the User model
  # for use in authorizing with CanCan
  # It checks if the user has a role among the ones we define here. 
  ROLES = [['Vet', :vet],['Assistant', :assistant],['Owner', :owner]]

  def role?(authorized_role)
    return false if role.nil?
    role.downcase.to_sym == authorized_role
    # to_sym creates the symbol version of the role (string added in the User table)
  end
  
  # login by username
  def self.authenticate(username, password)
    find_by_username(username).try(:authenticate, password)
  end

end
