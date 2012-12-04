Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'WcAaVQ5B0fu7tgRt2qNyg', '0fU3gd0TGk0X4z7S4G6ZD61x1LPSAJfwwD1rkSVnw'
  provider :facebook, '399921200081202', '6353f8505bed587d2738e0b02e60cf8e'
  provider :google_oauth2, '529518703017.apps.googleusercontent.com','fu1_fjSoptxO_sMEeF4UXFlx',{access_type: 'online', approval_prompt: ''}
end