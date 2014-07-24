require 'yaml'

class Roller
  class Operations

    def initialize
      @operations = :not_set
      populate
    end

    def initial_values
      {}.tap do |initial_hash|
        @operations.each do |operation, opts|
          initial_hash[operation.to_sym] = opts['initial']
        end
      end
    end

    def type_values
      {}.tap do |type_hash|
        @operations.each do |operation, opts|
          type_hash[operation.to_sym] = opts['type']
        end
      end
    end

    def run_op op, *args
      op = op.to_s
      raise 'no populated' if @operations == :not_set
      raise 'op not found' unless @operations.include?(op)
      do_operation op, *args
    end

    private

    def do_operation operation_name, register, value, input_buffer, output_buffer
      eval @operations[operation_name]['code'], binding, operation_name, 0
    end

    def populate
      @operations = YAML.load(
                      File.read(
                        File.join(File.dirname(__FILE__), 'operations.yaml')))
    end
  end
end
