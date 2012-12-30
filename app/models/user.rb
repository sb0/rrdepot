require 'digest/sha2'

class User < ActiveRecord::Base
#  attr_accessible :name, :passwd, :salt
  attr_accessible :name, :password, :password_confirmation
  validates :name, :presence => true, :uniqueness => true
 
  validates :password, :confirmation => true
  attr_accessor :password_confirmation
  attr_reader :password #sb: writer has custom implementation

  validate :password_must_be_present
#===========================================================================` 
    def User.authenticate(name, password)
      if user = find_by_name(name)
        if user.passwd == encrypt_password(password, user.salt)
          user
        end
      end
    end

    def User.encrypt_password(password, salt)
      Digest::SHA2.hexdigest(password + "streez" + salt)
    end

    # sb: implementing custom writer for password attrib (attr_reader above)
    def password=(password)
      @password = password
      # sb: abovec is default writer, but we also want to salt the hash
      if password.present?
        generate_salt
        self.passwd = self.class.encrypt_password(password, salt)
      end
    end 
  
#===============================================================================
  private

    # sb: 'password' is a virtual attribute 
    def password_must_be_present
      errors.add(:password, "Missing password") unless passwd.present?
    end

    def generate_salt
      self.salt = self.object_id.to_s + rand.to_s
    end

end
