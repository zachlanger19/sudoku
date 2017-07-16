#!/usr/bin/env ruby
require 'io/console'

class Solve
    def initialize
        @grid = Array.new(9) { Array.new(9) }
        @prior_grid
        @start = Time.now
        @finish = Time.now
        @time_spent_thinking = 0

        @grid = [[nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil,nil]]
        print_grid

        grid_is_correct = 'no'
        until grid_is_correct[0] == 'y'
            thinking_start = Time.now
            #input_value
            easy_input
            puts 'Is this correct?'
            print_grid
            grid_is_correct = gets.chomp.downcase
            @time_spent_thinking += Time.now - thinking_start
        end
        
        print_possible_values
        solve
        puts
    end

    # not necessary
    def easy_input
        cell = 0
        9.times do
            @grid[cell] = gets.chomp.split("")
            square = 0
            @grid[cell].each do |value|
                value == '0' ? @grid[cell][square] = nil : @grid[cell][square] = value.to_i
                square += 1
            end
            cell += 1
        end
    end
    
    def input_value
        puts 'Cells and Squares layout:'
        puts '123'
        puts '456'
        puts '789'
        finished_inputting_values = 'no'
        until finished_inputting_values[0] == 'y'
            puts 'Which cell?'
            cell = gets.chomp.to_i - 1
            puts 'Which square'
            square = gets.chomp.to_i - 1
            puts 'Whats the value? (nil for blank)'
            value = gets.chomp
            value == 'nil' ? value = nil : value = value.to_i
            @grid[cell][square] = value
            puts 'Are you finished inputting values?'
            finished_inputting_values = gets.chomp.downcase
        end
    end
    
    def print_grid
        initial_cell = 0
        initial_square = 0
        puts "+---------+---------+---------+"
        3.times do
            3.times do
                cell = initial_cell
                print "|"
                3.times do
                    square = initial_square
                    3.times do
                        if @grid[cell][square] == nil
                            print " _ "
                        else
                            print " #{@grid[cell][square]} "
                        end
                        square += 1
                    end
                    cell += 1
                    print "|"
                end
                puts
                initial_square += 3
                cell = initial_cell
            end
            puts "+---------+---------+---------+"
            initial_cell += 3
            initial_square = 0
        end
    end

    def possible_values(cell, square)
        values = (1..9).to_a
                    
        # delete values in same grid
        @grid[cell].each do |delete_value|
            values.delete(delete_value)
        end
                    
        # delete values in same row
        if [0,1,2].include?(cell)
            cell_values = [0,1,2]
        elsif [3,4,5].include?(cell)
            cell_values = [3,4,5]
        elsif [6,7,8].include?(cell)
            cell_values = [6,7,8]
        end
                    
        if [0,1,2].include?(square)
            square_values = [0,1,2]
        elsif [3,4,5].include?(square)
            square_values = [3,4,5]
        elsif [6,7,8].include?(square)
            square_values = [6,7,8]
        end
                    
        cell_values.each do |delete_cell|
            square_values.each do |delete_square|
                values.delete(@grid[delete_cell][delete_square])
            end
        end
                    
        # delete values in same coloumn
        if [0,3,6].include?(cell)
            cell_values = [0,3,6]
        elsif [1,4,7].include?(cell)
            cell_values = [1,4,7]
        elsif [2,5,8].include?(cell)
            cell_values = [2,5,8]
        end
                    
        if [0,3,6].include?(square)
            square_values = [0,3,6]
        elsif [1,4,7].include?(square)
            square_values = [1,4,7]
        elsif [2,5,8].include?(square)
            square_values = [2,5,8]
        end
                    
        cell_values.each do |delete_cell|
            square_values.each do |delete_square|
                values.delete(@grid[delete_cell][delete_square])
            end
        end

        return values
    end

    # not necessary
    def print_possible_values
        cell = 0
        square = 0
        9.times do
            9.times do
                if @grid[cell][square] == nil
                    print possible_values(cell, square)
                end
                square += 1
            end
            cell += 1
            square = 0
        end
        puts
    end
    
    def fill_in
        cell = 0
        square = 0
        9.times do
            9.times do
                if @grid[cell][square] == nil
                    if possible_values(cell, square).length == 1
                        @grid[cell][square] = possible_values(cell, square)[0]
                    end
                end
                square += 1
            end
            cell += 1
            square = 0
        end
    end

    def solved?
    	grid_is_solved = true
        @grid.each do |cell|
        	if cell.include?(nil)
                grid_is_solved = false
            end
        end
        if grid_is_solved == true
        	print_grid
            @finish = Time.now
        	abort("Solved in #{((@finish - @start) - @time_spent_thinking).round(5)} seconds")
        else
        	return  false
        end
    end

    def stuck?
    	@prior_grid == @grid ? true : false
    end

    def broken?
    	cell = 0
        square = 0
        9.times do
            9.times do
                if @grid[cell][square] == nil
                    if possible_values(cell, square).length == 0
                        return true
                    end
                end
                square += 1
            end
            cell += 1
            square = 0
        end
        return false
    end

    # not necessary
    def continue_tests
        thinking_start = Time.now
        print "Continue?"                                                                                                    
        continue = gets.chomp                                                                                                            
        if continue != ""
            abort("Aborted")
        end
        @time_spent_thinking += Time.now - thinking_start
    end

    def solve
        until solved? || stuck?
            @prior_grid = @grid.inject([]) { |a,element| a << element.dup }
            fill_in
        end
        if !broken?
            cell = 0
            square = 0
            9.times do
                9.times do 
                    if @grid[cell][square] == nil
                        backup_grid =  @grid.inject([]) { |a,element| a << element.dup }

                        possible_values(cell, square).each do |test_value|
                            @grid[cell][square] = test_value
                            solve
                            @grid = backup_grid.inject([]) { |a,element| a << element.dup }
                        end
                        return
                    end
                    square += 1
                end
                cell += 1
                square = 0
            end
        end
    end
end

solve = Solve.new



