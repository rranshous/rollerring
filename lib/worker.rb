require 'msgpack'
require 'json'
require 'nio'

class WorkerPool

  def initialize pool_size=4, &work

    @work = work
    @pool_size = pool_size
    @selector = NIO::Selector.new
    @workers = []

    create_workers
  end

  def map all_work

    completed_work = []
    idle_workers = Array.new @workers
    work_queue = Array.new all_work

    while completed_work.length != all_work.length
      until idle_workers.empty? || work_queue.empty?
        idle_workers.shift.push(work_queue.shift)
      end
      ready = @selector.select
      unless ready.nil?
        finished_workers = ready.map { |m| m.value }
        completed_work += finished_workers.map { |worker| worker.pop }
        idle_workers += finished_workers
      end
    end

    completed_work
  end

  private

  def create_workers

    @workers += @pool_size.times.map do
      worker = Worker.new &@work
      monitor = worker.register do |input|
        @selector.register(input, :r)
      end
      monitor.value = worker
      worker
    end
  end
end


class Worker

  def initialize &work

    @input, output = IO.pipe
    input, @output = IO.pipe
    @proc = fork do
      @input.close
      @output.close
      loop do
        encoded_data = input.readline.chomp
        data = self.class.deserialize(encoded_data)
        result = work.call(data['work'])
        encoded_result = self.class.serialize({'result' => result})
        output.puts(encoded_result)
      end
    end
    Process.detach @proc
    output.close
    input.close
  end

  def push input
    @output.puts(self.class.serialize({'work' => input}))
  end

  def pop
    self.class.deserialize(@input.readline.chomp)['result']
  end

  def register &blk
    blk.call @input
  end


  def self.serialize data
    #data.to_msgpack
    data.to_json
  end

  def self.deserialize data
    #MessagePack.unpack(data)
    JSON.parse data
  end
end

