#!/usr/bin/ruby

class Stat
	attr_reader :title, :file, :total, :unknown, :ok, :ignore

	def initialize(title, file)
		@title = title
		@file = file
		@total = 0
		@unknown = 0
		@ok = 0
		@ignore = 0
	end

	def calc!
		File.open(file + ".md").each do |line|
			if line =~ /.*\.phpt.*/
				@total += 1
				case line
				when /.*state\-unknown.*/
					@unknown += 1
				when /.*state\-ok.*/
					@ok += 1
				when /.*state\-ignore.*/
					@ignore += 1
				end
			end
		end
	end
end

stats = [
	Stat.new("Core tests", "projects/jbj/core_tests"),
	Stat.new("Zend tests", "projects/jbj/zend_tests")
]

stats.each do |stat|
	stat.calc!
end

stats.each do |stat|
	done = 100 * (stat.ok + stat.ignore) / stat.total
	puts <<-eos
## [#{stat.title}]({{ BASE_PATH }}/#{stat.file}.html)

<table style="width: 100%; height: 20px;">
	<tr>
		<td width="#{done}%" style="background: green;"></td>
		<td width="#{100-done}%"></td>
	</tr>
</table>

* Total: #{stat.total}
* Ok: #{stat.ok}
* Ignore (for various reasons): #{stat.ignore}
* Unknown (not yet implemented): #{stat.unknown}

	eos
end