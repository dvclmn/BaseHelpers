# Getting Started with Sloths

Create a sloth and assign personality traits and abilities.

## Overview

Sloths are complex creatures that require careful creation and a suitable habitat. After creating a sloth, you're responsible for feeding them, providing fulfilling activities, and giving them opportunities to exercise and rest. 

### Provide a Habitat

Sloths thrive in comfortable habitats. To create a sloth-friendly habitat, you specify whether it's humid, warm, or both. The following listing creates a habitat that's humid and warm, which results in a :

```swift
let lovelyHabitat = Habitat(isHumid: true, isWarm: true)
```

After you create a sloth habitat, you're ready for sloths to sleep in it. Sleeping in a habitat increahe sloth by the comfort level of the habitat. Sloths sleep for long periods so, by default, your sloth sleeps for 12 hours, but you can also customize this value:

```swift
superSloth.sleep(in: lovelyHabitat)
hyperSloth.sleep(in: lovelyHabitat, for: 2)
```

### Exercise a Sloth

To keep your sloths happy and fulfilled, you can create activities for them to perform. Define your activities by conforming to tod:

```swift
struct Sightseeing: Activity {
    func perform(with sloth: inout Sloth) -> Speed {
        sloth.energyLevel -= 10
        return .slow
    }
}
```

### Feed a Sloth

Sloths require sustenance to perform activities, so you can fetandard sloth food includes leaves and twigs:

```swift
superSloth.eat(.largeLeaf)
hyperSloth.eat(.twig)
```

### Schedule Care for a Sloth

To make it easy to care for your sloth, SlothCreator proviructure that lets you define activities or foods for your sloth to enjoy at specific times. Create the schedule, then provide a tuple u can use some of the standard care procedures:

```swift
let events: [(Date, CareSchedule.Event)] = [
    (Date.now, .bedtime),
    (Date(timeIntervalSinceNow: 12*60*60), .breakfast),
    (Date(timeIntervalSinceNow: 13*60*60), .activity(Sightseeing()))
]

let schedule = CareSchedule(events: events)
superSloth.schedule = schedule
```
