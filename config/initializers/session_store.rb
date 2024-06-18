Rails.application.config.session_store :active_record_store,
                                       key: Rails.env.production? ? "_app_session" : "_app_session_#{Rails.env}"
