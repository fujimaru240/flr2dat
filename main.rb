# frozen_string_literal: true

require './models/definition_generator'

DefinitionGenerator.new(ARGV).execute

exit
