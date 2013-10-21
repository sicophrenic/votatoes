#-*- coding: utf-8 -*-#
Tmdb::Api.key(Rails.env.development? ? TMDB_SECRET_KEY : ENV['TMDB_SECRET_KEY'])