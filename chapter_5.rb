############## Page 87 ##############
class Trip
  attr_reader :bicycles, :customers, :vehicle

  # this 'mechanic' argument could be of any class
  def prepare(mechanic)
    mechanic.prepare_bicycles(bicycles)
  end

  # ...
end

# if you happen to pass an instance of *this* class,
# it works
class Mechanic
  def prepare_bicycles(bicycles)
    bicycles.each {|bicycle| prepare_bicycle(bicycle)}
  end

  def prepare_bicycle(bicycle)
    #...
  end
end
# The prepare method has no dependency on the MECHANIC class but it does depend on receiving and object that can respond to prepare_bycicles
############## Page 88 ##############
# Trip preparation becomes more complicated
class Trip
  attr_reader :bicycles, :customers, :vehicle

  def prepare(preparers)
    preparers.each {|preparer|
      case preparer
      when Mechanic
        preparer.prepare_bicycles(bicycles)
      when TripCoordinator
        preparer.buy_food(customers)
      when Driver
        preparer.gas_up(vehicle)
        preparer.fill_water_tank(vehicle)
      end
    }
  end
end
#TRIP's prepare method might be forced to change because of a change elsewhere and it might inecpectedly break as the result
#of a distinct, unrelated change.
# when you introduce TripCoordinator and Driver
class TripCoordinator
  def buy_food(customers)
    # ...
  end
end

class Driver
  def gas_up(vehicle)
    #...
  end

  def fill_water_tank(vehicle)
    #...
  end
end
#this dependent laden code is a natural outgrowth of a class-based perspective.
############## Page 93 ##############
# Trip preparation becomes easier
class Trip
  attr_reader :bicycles, :customers, :vehicle

  def prepare(preparers)
    preparers.each {|preparer|
      preparer.prepare_trip(self)}
  end
end

# when every preparer is a Duck
# that responds to 'prepare_trip'
class Mechanic
  def prepare_trip(trip)
    trip.bicycles.each {|bicycle|
      prepare_bicycle(bicycle)}
  end

  # ...
end

class TripCoordinator
  def prepare_trip(trip)
    buy_food(trip.customers)
  end

  # ...
end

class Driver
  def prepare_trip(trip)
    vehicle = trip.vehicle
    gas_up(vehicle)
    fill_water_tank(vehicle)
  end
  # ...
end
#The PREPARE method can now accept new PREPARERS without being forced to change.
############## Page 96 ##############
class Trip
  attr_reader :bicycles, :customers, :vehicle

  def prepare(preparers)
    preparers.each {|preparer|
      case preparer
      when Mechanic
        preparer.prepare_bicycles(bicycles)
      when TripCoordinator
        preparer.buy_food(customers)
      when Driver
        preparer.gas_up(vehicle)
        preparer.fill_water_tank(vehicle)
      end
    }
  end
end
#dbegins to define the underlying duck type.
############## Page 97 ##############
  if preparer.kind_of?(Mechanic)
    preparer.prepare_bicycles(bicycle)
  elsif preparer.kind_of?(TripCoordinator)
    preparer.buy_food(customers)
  elsif preparer.kind_of?(Driver)
    preparer.gas_up(vehicle)
    preparer.fill_water_tank(vehicle)
  end
#Using kind_of? is no different than using a case statement that switches on class
############## Page 97 ##############
  if preparer.responds_to?(:prepare_bicycles)
    preparer.prepare_bicycles(bicycle)
  elsif preparer.responds_to?(:buy_food)
    preparer.buy_food(customers)
  elsif preparer.responds_to?(:gas_up)
    preparer.gas_up(vehicle)
    preparer.fill_water_tank(vehicle)
  end
#Difference between this and the last ex. is the stability of the classes being checked. The other is more stable because it depends on core Ruby classes.
############## Page 99 ##############
# A convenience wrapper for <tt>find(:first, *args)</tt>.
# You can pass in all the same arguments to this
# method as you can to <tt>find(:first)</tt>.
def first(*args)
  if args.any?
    if args.first.kind_of?(Integer) ||
         (loaded? && !args.first.kind_of?(Hash))
      to_a.first(*args)
    else
      apply_finder_options(args.first).first
    end
  else
    find_first
  end
end
# !x
