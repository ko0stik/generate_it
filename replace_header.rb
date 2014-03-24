# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    replace_header.rb                                  :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: hmichals <hmichals@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2014/02/16 21:11:29 by hmichals          #+#    #+#              #
#    Updated: 2014/02/16 22:09:17 by hmichals         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/usr/bin/ruby

#First some colors!
class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def blue
    colorize(34)
  end

  def yellow
    colorize(33)
  end

  def pink
    colorize(35)
  end
end

require 'fileutils'
objs = "./objs/"
includes = "./includes/"
srcs = "./srcs/"
user = `echo $USER`
mail = `echo $MAIL`
home = `echo $HOME`.delete!("\n")
time = Time.new
offset =  " " * (9 - user.size)
mail.delete!("\n")

#The default menu
if ARGV[0] != 0
  choice = ARGV[0]
  else
  choice = 0
end
while choice != "1" && choice != "2" && choice != "3" && choice != "4"
  system("clear")
  puts "Hello #{user.delete("\n").red}! What is it you want to achieve?".center(120).pink
  puts "-------------------------------------------------------------------------------------------------".red
  puts "#1".red + " ->update headers prototypes                                                                  #{"|".red}"
  puts "#2".red + " ->exit".blue + "                                                                                       |".red
  puts "-------------------------------------------------------------------------------------------------".red
  puts "\n\n\n\n\n\n\n\nhmichals v0.1".blue
  choice = gets.chomp
end
system("clear")
case choice

when "1" then
  puts "path to the folder:"
  path = STDIN.gets.chomp
  path.sub!("~", home)
  if path[-1, 1] != "/"
    path += "/"
  end
  puts path
  offset_p = 51
  user.delete!("\n")
  pattern = Regexp.new(/.*\.c/)
  c_files = Array.new
  count = 0
  c_files = Dir.glob(path + '*.c')
  c_files.each do |f|
    f.delete!("\n")
  end
  print "\nfiles which header will be replaced:\n".blue
  c_files.each do |f|
    puts f.gsub(path, '')
  end
  puts "confirm?[y/n]"
  rep = gets.chomp
  if rep == "y"

    #les choses serieuses commencent, on check si le header est la et si oui, on remaplce.
    c_files.each do |f|
      tmp = File.read(f)
      if tmp.include?(":+:      :+:    :+:")
        system("sed -i.bak '1,11'd #{f}")
        system("rm #{f}" + ".bak")
      end
      tmp = File.read(f)
      File.open(f, 'w') { |d|
      d.puts("/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   #{f.sub(path, '')} "+ " " * (50 - f.sub(path, '').size)  + ":+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: #{user} <#{mail}>" + offset * 2 + "          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: #{time.strftime("%Y/%m/%d %H:%M:%S")} by #{user}" + offset + "          #+#    #+#             */
/*   Updated: #{time.strftime("%Y/%m/%d %H:%M:%S")} by #{user}" + offset + "         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
" + tmp)}

    end
  end
when "2" then
puts "exit".blue
end
