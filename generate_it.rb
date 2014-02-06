# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    utilities.rb                                       :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: hmichals <hmichals@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2014/02/05 01:07:34 by hmichals          #+#    #+#              #
#    Updated: 2014/02/06 16:45:56 by hmichals         ###   ########.fr        #
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

#We set the environment
require 'fileutils'
objs = "./objs/"
includes = "./includes/"
srcs = "./srcs/"
user = `echo $USER`
mail = `echo $MAIL`
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
  puts "#2".red + " ->create a new project repo                                                                  #{"|".red}"
  puts "#3".red + " ->update a project repo (must be done from the project root folder)                          #{"|".red}"
  puts "#4".red + " ->exit".blue + "                                                                                       |".red
  puts "-------------------------------------------------------------------------------------------------".red
  puts "\n\n\nNB:".red + "		Please note that this script is still being under construction."
  puts "\nDONE".blue + "		- Now with headers preimplemented (for standard logins)
		- Now names with less than 8 chars also have a correct header
		- your project.h is now updated accordingly to your sources.c, can still be buggy though"
  puts "\nTODOLIST".blue + "	- BUGFIX: deleting main.c from the srcs repo messes up the Makefile
		- the section 1 is still empty"
  puts "\n\n\n\n\n\n\n\nhmichals v0.2".blue
  choice = gets.chomp
end
system("clear")
case choice
    #Still under construction
when "1" then

  prot = Array.new
  prot_h = Array.new
  project = ""

  if !File.exist?("Makefile") || !File.exist?(srcs) || !File.exist?(includes)
    puts("Error".red + ", it seems you are not in a correct directory or you don't have the correct architecture")
  else
    c_files_make = Array.new
    count = 0
    c_files = Dir.glob(srcs + '*.c')
    c_files.each do |f|
      File.open(f, 'r'){ |f_cont|
        f_cont.each_line do |line|
        if line.match(/^(?!static)(^[\w].*[)]$)/) && !line.include?("main(")
          prot.push(line.strip)
        end
      end
      }
    end
    File.open("Makefile", 'r'){ |f|
      f.each_line do |line|
        if line.match (/^NAME =/)
          project = line
        end
      end
    }
    project.gsub!("NAME = ", "")
    project.delete!("\n")
    puts("\nChecking if your #{project.red}.h is up-to-date.".blue)
    puts("")
puts("===============================================================")
puts("We check if all functions have their prototype in the header")
puts("")
    File.open(includes + project + ".h", 'r'){ |f|
        f.each_line do |line|
        if line.match(/^(?!static|typedef|extern)(^[\w].*[;]$)/)
          prot_h.push(line.strip)
        end
      end
    }
  end

  count = 0
  prot.each do |p|
    bol = 0
    prot_h.each do |h|
      if p.gsub(/\s+/, "") == h.gsub(/\s+/, "").delete(";")
        bol = 1
        puts(h.split[1].gsub(/\(.*/, "") + "() >>" + " MATCH".green)
      end
    end
    if bol == 0
      puts(p.split[1].gsub(/\(.*/, "") + "() >>" + " NO MATCH".red + " adding it to #{project.blue}.h")
      tmp = File.read(includes + project + ".h")
      count += 1
      tmp.gsub!("/* function prototypes */\n", "/* function prototypes */\n\n" + p + ";")
      File.open(includes + project + ".h", 'w'){ |f| f.puts(tmp) }
    end
  end

puts("")
puts("===============================================================")
puts("Now we check if the header does not contain non-existent function prototypes")
puts("")

  count_bis = 0

  prot_h.each do |p|
    bol = 0
    prot.each do |h|
      if p.gsub(/\s+/, "").delete(";") == h.gsub(/\s+/, "")
        bol = 1
        puts(h.split[1].gsub(/\(.*/, "") + "() >>" + " MATCH".green)
      end
    end
    if bol == 0
      puts(p.split[1].gsub(/\(.*/, "") + "() >>" + " NO MATCH".red + " deleting it from #{project.blue}.h")
      tmp = File.read(includes + project + ".h")
      count_bis += 1
      tmp.gsub!(p + "\n", "")
      File.open(includes + project + ".h", 'w'){ |f| f.puts(tmp) }
    end
  end

  puts("")
  puts("#{count.to_s.green} prototypes added and #{count.to_s.green} removed from your #{project.red}.h, please check the padding")
  #Create for you a standard repo with everything you should have in it
when "2" then
  puts "Name of the #{"project".blue}:".red
  project = STDIN.gets.chomp
  project.gsub!(/\s+/, "_")
  offset_pro = 49 - project.size
  system("echo $USER > auteur")
  user.delete!("\n")
  FileUtils.mkdir_p(objs)
  File.new(objs + ".gitignore", 'w')
  FileUtils.mkdir_p(includes)
  if !File.exist?(includes + project +".h")
    File.open(includes + project + ".h", 'w') {|f|
      f.puts("/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   #{project}.h" + " " * offset_pro + ":+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: #{user} <#{mail}>" + offset * 2 + "          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: #{time.strftime("%Y/%m/%d %H:%M:%S")} by #{user}" + offset + "          #+#    #+#             */
/*   Updated: #{time.strftime("%Y/%m/%d %H:%M:%S")} by #{user}" + offset + "         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
")
      f.puts("")
      f.puts("#ifndef #{project.upcase}_H")
      f.puts("# define #{project.upcase}_H")
      f.puts("")
      f.puts("/* function prototypes */")
      f.puts("")
      f.puts("#endif /* !#{project.upcase}_H */")
      }
    end
  FileUtils.mkdir_p(srcs)
  if !File.exist?(srcs + "main.c")
    File.open(srcs + "main.c", 'w'){
      |f|
      f.puts("/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: #{user} <#{mail}>" + offset * 2 + "          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: #{time.strftime("%Y/%m/%d %H:%M:%S")} by #{user}" + offset + "          #+#    #+#             */
/*   Updated: #{time.strftime("%Y/%m/%d %H:%M:%S")} by #{user}" + offset + "         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
")
      f.puts("\n#include <unistd.h>

int		main(void)
{
	write(1,\"Hello " + user + "\", " + "#{user.length + 6}" + ");
	return (0);
}")
  }
    end
    File.open("Makefile", 'w'){
    |f|
    f.puts("#******************************************************************************#
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #")
    f.puts("#    By: #{user} <#{mail}>" + offset * 2 + "          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: #{time.strftime("%Y/%m/%d %H:%M:%S")} by #{user}" + offset + "          #+#    #+#              #
#    Updated: #{time.strftime("%Y/%m/%d %H:%M:%S")} by #{user}" + offset + "         ###   ########.fr        #
#                                                                              #
#******************************************************************************#")
    f.puts("\nNAME = " + project)
    f.puts("")
    f.puts("CC = llvm-gcc")
    f.puts("")
    f.puts("CFLAGS = -Wall -Wextra -Werror -O3 -I includes/ -g")
    f.puts("")
    f.puts("SRCDIR = " + srcs)
    f.puts("")
    f.puts("OBJDIR = " + objs)
    f.puts("")
    f.puts("SRC =	main.c")
    f.puts("")
    f.puts("LDFLAGS = -I includes -g")
    f.puts("")
    f.puts("OBJ = $(SRC:%.c=%.o)")
    f.puts("")
    f.puts("OBJ_LIST = $(addprefix $(OBJDIR), $(OBJ))")
    f.puts("")
    f.puts("all: $(NAME)")
    f.puts("")
    f.puts("$(NAME): $(OBJ_LIST)
	$(CC) $(OBJ_LIST) -o $(NAME) $(LDFLAGS)")
    f.puts("")
    f.puts("$(OBJDIR)%.o: $(SRCDIR)%.c")
    f.puts("	@$(CC) -o $@ -c $< $(CFLAGS)")
    f.puts("")
    f.puts("clean:
	/bin/rm -fr $(OBJ_LIST)

fclean: clean
	/bin/rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re")
    puts("\nOperation complete".green)
    puts("\nPlease press #{"ENTER".red} to exit")
    STDIN.gets.chomp
    system("clear")
  }
  when "3" then
    puts("\nChecking if the srcs folder contains any file not present in the Makefile".blue)
    if !File.exist?("Makefile") || !File.exist?(srcs)
      puts("Error".red + ", it seems you are not in a correct directory")
    else
      pattern = Regexp.new(/.*\.c/)
      c_files_make = Array.new
      count = 0
      c_files = Dir.glob(srcs + '*.c')
      c_files.each do |f|
      f.sub!(srcs, '')
    end
      File.open("Makefile", 'r'){ |f|
      f.each_line do |line|
        if line.match(pattern) && !line.match(/.*\.o/)
          line.sub!(/SRC =	/, "")
          line.sub!(/ \\/, "")
          line.sub!(/\s+/, "")
          if !c_files_make.include?(line)
            c_files_make.push(line)
          end
        end
    end
    }
      c_files.each do |item|
      item.delete!("\n")
      puts("Checking for #{item.blue}")
      is_it_here = 0
      tmp = File.read("Makefile")
      c_files_make.each do |item_make|
        item_make.delete!("\n")
        if item.to_s == item_make.to_s
          puts("MATCH for #{item.pink} >> nothing to do")
          is_it_here = 1
        end
      end
      if is_it_here == 1
      else
        puts("NO MATCH" + " > adding the element: #{item.blue}".red)
        count += 1
        if tmp.include? ("SRC =	main.c\n")
          replace = tmp.gsub(/SRC =	main.c\n/, "SRC =	main.c \\\n		" + item + " \\\n")
        else
          replace = tmp.gsub(/SRC =	main.c \\\n/, "SRC =	main.c \\\n		" + item + " \\\n")
        end
        File.open("Makefile", 'w') {|file| file.puts replace}
      end
    end
      #We check here if there is any files removed from the src folder and still present in the makefile.
      puts("\nChecking if any file was removed from the srcs folder and not from the Makefile".blue)
      count_2 = 0
      tmp = File.read("Makefile")
      c_files_make.each do |c_m|
      if !c_files.include? (c_m)
        count_2 += 1
        puts("NO MATCH" + " > deleting the element: #{c_m.blue}".red)
        system("sed -i.bak '/#{c_m}/d' Makefile")
        system("rm Makefile.bak")
      end
    end
    puts("\nOperation complete:")
    puts("#{count.to_s.green} element[s] added and #{count_2.to_s.green} element[s] removed from your Makefile. Please press enter to leave the program")
    STDIN.gets.chomp
    system("clear")
    end
  when "4" then
  end
