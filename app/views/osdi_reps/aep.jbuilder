# frozen_string_literal: true

json.motd 'Welcome to the PYR OSDI API Entry Point (AEP)'

json._links do
  json.set! 'osdi:people' do
    json.href "#{@pfx}/osdi/people"
    json.title 'The collection of Reps'
  end

  json.set! 'pyr:demo' do
    json.href "#{@pfx}/osdi/people?lat=40.740916&long=-73.999769"
    json.title 'Demo query for representatives near Chelsea NYC, the center of the universe'
  end
end
