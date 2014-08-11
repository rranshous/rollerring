require 'json'

class Worker

  def self.map workers, all_work
    workers.take(all_work.length).zip(all_work).each do |worker, work|
      worker.push(work)
    end
    .map do |worker, work|
      worker.pop
    end
  end

  def initialize &work
    work
    @input, output = IO.pipe
    input, @output = IO.pipe
    puts "FORKING"
    @proc = fork do
      @input.close
      @output.close
      loop do
        encoded_data = input.readline
        data = JSON.parse(encoded_data)
        result = work.call(data['work'])
        encoded_result = JSON.dump({'result' => result})
        output.puts(encoded_result)
      end
    end
    Process.detach @proc
    output.close
    input.close
    puts "DONE FORKING: #{@proc}"
  end

  def push input
    @output.puts({'work' => input}.to_json)
  end

  def pop
    JSON.parse(@input.readline)['result']
  end
end

