# SocialBridge - Decentralized Community Connection Platform

[![Stacks Blockchain](https://img.shields.io/badge/Stacks-Blockchain-5546FF)](https://www.stacks.co/)
[![Clarity](https://img.shields.io/badge/Language-Clarity-blue)](https://clarity-lang.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A comprehensive blockchain-based social platform that tracks community engagement, rewards meaningful connections, and builds inclusive communities through tokenized incentives.

## 🌟 Overview

SocialBridge is a decentralized social platform built on the Stacks blockchain that revolutionizes community building by rewarding authentic engagement, volunteerism, mentorship, and social connections. Members earn SCT (SocialBridge Connection Tokens) for contributing to community growth and helping others.

## ✨ Core Features

### 🎯 Platform Components

- **Community Categories**: Organized interest groups with activity and inclusivity metrics
- **Event Management**: Create and attend community events with token-based entry fees
- **Help Marketplace**: Request and provide community assistance
- **Volunteer Opportunities**: Organize and participate in cause-driven activities
- **Mentorship Programs**: Structured knowledge-sharing with experienced mentors
- **Social Connections**: Track and strengthen community relationships
- **Reputation System**: Earn reputation through positive engagement
- **Token Rewards**: Comprehensive incentive system for all activities

### 💎 Token Economics (SCT)

- **Token Name**: SocialBridge Connection Token
- **Symbol**: SCT
- **Decimals**: 6
- **Max Supply**: 1,000,000 SCT

**Reward Structure:**
- 🎪 Event Hosting: 90 SCT
- 🎫 Event Attendance: 35 SCT
- 🤝 Community Help: 50 SCT
- 🌱 Volunteer Work: 75 SCT
- 👨‍🏫 Mentorship: 85 SCT
- 🔗 Social Connection: 20 SCT

## 🏗️ Architecture

### Data Structures

#### Member Profiles
```clarity
{
  username: string-ascii(32),
  social-style: string-ascii(16),
  interests: string-ascii(200),
  events-hosted: uint,
  events-attended: uint,
  help-requests-made: uint,
  help-provided: uint,
  volunteer-hours: uint,
  mentoring-sessions: uint,
  reputation-score: uint,
  join-date: uint,
  last-activity: uint
}
```

**Social Styles**: `extrovert`, `introvert`, `ambivert`  
**Starting Reputation**: 100 points

#### Community Categories
```clarity
{
  category-name: string-ascii(64),
  focus-area: string-ascii(32),
  activity-level: uint,        // 1-5
  inclusivity-score: uint,     // 1-10
  growth-potential: uint,      // 1-5
  verified: bool
}
```

**Focus Areas**: `social`, `professional`, `hobby`, `support`

#### Community Events
```clarity
{
  organizer: principal,
  category-id: uint,
  event-title: string-ascii(128),
  event-description: string-ascii(500),
  event-type: string-ascii(32),
  max-attendees: uint,
  current-attendees: uint,
  event-date: uint,
  duration-hours: uint,
  location: string-ascii(100),
  entry-fee: uint,
  skill-level: uint,           // 1-5
  active: bool
}
```

**Event Types**: `meetup`, `workshop`, `volunteer`, `social`

#### Help Requests
```clarity
{
  requester: principal,
  category-id: uint,
  help-title: string-ascii(128),
  help-description: string-ascii(400),
  urgency-level: uint,         // 1-5
  skill-required: string-ascii(64),
  time-commitment: uint,       // hours
  help-type: string-ascii(32),
  location-preference: string-ascii(64),
  helper: optional(principal),
  request-date: uint,
  completion-date: optional(uint),
  status: string-ascii(16),
  resolved: bool
}
```

**Help Types**: `advice`, `task`, `skill`, `emotional`  
**Status Values**: `open`, `in-progress`, `completed`

#### Volunteer Opportunities
```clarity
{
  organizer: principal,
  opportunity-title: string-ascii(128),
  cause-description: string-ascii(400),
  volunteer-type: string-ascii(32),
  skills-needed: string-ascii(200),
  time-commitment: uint,
  location: string-ascii(100),
  start-date: uint,
  end-date: uint,
  volunteers-needed: uint,
  current-volunteers: uint,
  impact-area: string-ascii(64),
  active: bool
}
```

**Volunteer Types**: `cleanup`, `teaching`, `support`, `fundraising`

#### Mentorship Programs
```clarity
{
  mentor: principal,
  program-title: string-ascii(128),
  expertise-area: string-ascii(64),
  program-description: string-ascii(400),
  target-audience: string-ascii(100),
  session-frequency: string-ascii(16),
  max-mentees: uint,
  current-mentees: uint,
  program-duration: uint,
  application-fee: uint,
  created-date: uint,
  active: bool
}
```

**Session Frequencies**: `weekly`, `biweekly`, `monthly`

#### Social Connections
```clarity
{
  connection-type: string-ascii(16),
  connection-date: uint,
  interaction-frequency: uint,    // 1-10
  mutual-interests: string-ascii(200),
  connection-strength: uint,      // 1-10
  last-interaction: uint
}
```

**Connection Types**: `friend`, `colleague`, `mentor`, `mentee`

## 📖 Usage Guide

### Creating a Community Category

```clarity
(contract-call? .socialbridge add-community-category
  "Tech Enthusiasts"
  "professional"
  u4                    ;; activity-level
  u9                    ;; inclusivity-score
  u5                    ;; growth-potential
)
```

### Hosting a Community Event

```clarity
(contract-call? .socialbridge create-community-event
  u1                    ;; category-id
  "Web3 Workshop"
  "Learn blockchain development fundamentals"
  "workshop"
  u30                   ;; max-attendees
  u3                    ;; duration-hours
  "Downtown Community Center"
  u10000000            ;; entry-fee (10 SCT)
  u2                    ;; skill-level
)
```

### Attending an Event

```clarity
(contract-call? .socialbridge attend-event u1)
```

### Creating a Help Request

```clarity
(contract-call? .socialbridge create-help-request
  u1                    ;; category-id
  "Need website design help"
  "Looking for UI/UX guidance for non-profit site"
  u3                    ;; urgency-level
  "Web Design"
  u5                    ;; time-commitment
  "advice"
  "Remote or Downtown"
)
```

### Providing Help

```clarity
(contract-call? .socialbridge provide-help u1)
```
**Requirements**: Reputation score ≥ 120 points

### Creating a Volunteer Opportunity

```clarity
(contract-call? .socialbridge create-volunteer-opportunity
  "Beach Cleanup Initiative"
  "Monthly beach cleanup to protect marine life"
  "cleanup"
  "Physical fitness, enthusiasm"
  u4                    ;; time-commitment
  "Ocean Beach"
  u20                   ;; volunteers-needed
  "Environmental"
)
```
**Requirements**: Reputation score ≥ 200 points

### Creating a Mentorship Program

```clarity
(contract-call? .socialbridge create-mentorship-program
  "Career Development Mentorship"
  "Software Engineering"
  "1-on-1 career guidance for junior developers"
  "Entry to mid-level developers"
  "biweekly"
  u5                    ;; max-mentees
  u12                   ;; program-duration (weeks)
  u50000000            ;; application-fee (50 SCT)
)
```
**Requirements**: Reputation score ≥ 300 points

### Creating Social Connections

```clarity
(contract-call? .socialbridge create-social-connection
  'SP2ABC...           ;; member-b
  "friend"
  "blockchain, hiking, photography"
  u8                    ;; connection-strength
)
```

### Updating Your Username

```clarity
(contract-call? .socialbridge update-member-username "alice_crypto")
```

### Transferring Tokens

```clarity
(contract-call? .socialbridge transfer
  u100000000           ;; amount (100 SCT)
  tx-sender
  'SP2ABC...           ;; recipient
  (some 0x123456)      ;; optional memo
)
```

## 🔍 Read-Only Functions

Query platform data:

```clarity
;; Get member profile
(contract-call? .socialbridge get-member-profile 'SP2ABC...)

;; Get community category
(contract-call? .socialbridge get-community-category u1)

;; Get event details
(contract-call? .socialbridge get-community-event u1)

;; Get event attendance
(contract-call? .socialbridge get-event-attendance u1 'SP2ABC...)

;; Get help request
(contract-call? .socialbridge get-help-request u1)

;; Get volunteer opportunity
(contract-call? .socialbridge get-volunteer-opportunity u1)

;; Get mentorship program
(contract-call? .socialbridge get-mentorship-program u1)

;; Get social connection
(contract-call? .socialbridge get-social-connection 'SP2ABC... 'SP2DEF...)

;; Get token balance
(contract-call? .socialbridge get-balance 'SP2ABC...)

;; Get total supply
(contract-call? .socialbridge get-total-supply)
```

## 🎖️ Reputation System

### Reputation Scoring

| Action | Reputation Gain |
|--------|----------------|
| Host Event | +20 points |
| Attend Event | +8 points |
| Provide Help | +15 points |
| Create Volunteer Opportunity | +25 points |
| Create Mentorship Program | +30 points |
| Create Social Connection | +5 points |

### Reputation Thresholds

- **Help Provider**: 120+ points
- **Volunteer Organizer**: 200+ points
- **Mentor**: 300+ points

### Benefits of High Reputation

- Unlock mentorship capabilities
- Organize volunteer opportunities
- Enhanced trust in help marketplace
- Community leadership opportunities
- Priority access to exclusive events

## 🛡️ Security Features

- **Input Validation**: Comprehensive checks on all parameters
- **Authorization**: Role-based access for sensitive operations
- **Duplicate Prevention**: No duplicate reviews, connections, or registrations
- **Capacity Management**: Event attendee limits enforced
- **Token Security**: Transfer authentication and balance verification
- **Reputation Gating**: Quality control through reputation requirements
- **Supply Cap**: Maximum token supply enforcement

## 🎯 Use Cases

### For Individuals
- Find local community events
- Request help from skilled community members
- Offer expertise through mentorship
- Build meaningful social connections
- Track community contributions

### For Organizations
- Host fundraising events
- Recruit volunteers for causes
- Organize workshops and training
- Build community engagement
- Measure social impact

### For Educators
- Create mentorship programs
- Share knowledge and skills
- Connect with mentees
- Build teaching reputation
- Earn rewards for education

### For Social Impact
- Coordinate volunteer activities
- Support community causes
- Track volunteer hours
- Measure impact metrics
- Build sustainable communities

## 💡 Platform Mechanics

### Event Entry Fees
- Organizers set token-based entry fees
- Fees transfer directly to organizers
- Promotes quality event organization
- Self-sustaining event ecosystem

### Help Marketplace
- Open requests visible to all
- Helpers claim requests
- Reputation-gated access ensures quality
- Track completion and outcomes

### Mentorship Economy
- Mentors set application fees
- Duration-based programs
- Structured session frequencies
- Quality guaranteed through reputation

## 🚀 Getting Started

### For New Members

1. **Join the Platform**: Automatic profile creation on first interaction
2. **Explore Categories**: Browse community focus areas
3. **Attend Events**: Start with event attendance to build reputation
4. **Build Connections**: Network with like-minded individuals
5. **Earn Reputation**: Participate consistently to unlock features
6. **Give Back**: Provide help and mentorship as you grow

### For Community Organizers

1. **Create Category**: Define your community focus
2. **Host Events**: Organize engaging community activities
3. **Set Standards**: Use entry fees to ensure commitment
4. **Track Growth**: Monitor attendance and engagement
5. **Build Leadership**: Gain reputation through consistent organizing

## 📊 Platform Statistics

Automatically tracked metrics:
- Total events hosted and attended
- Help requests created and fulfilled
- Volunteer opportunities and participation
- Mentorship programs and sessions
- Social connections formed
- Community growth over time
- Token distribution and circulation

## 🔮 Future Enhancements

### Planned Features
- Event feedback and rating system
- Volunteer hour verification
- Mentorship session tracking
- Community governance (DAO)
- Achievement badges (NFTs)
- Skill verification system
- Impact reporting dashboard
- Mobile app integration

### Community Governance
- Vote on category additions
- Approve volunteer causes
- Set platform policies
- Allocate community funds
- Verify trusted members

## 📝 Error Codes

- `u100`: Owner-only operation
- `u101`: Resource not found
- `u102`: Resource already exists
- `u103`: Unauthorized action
- `u104`: Invalid input parameters
- `u105`: Insufficient token balance
- `u106`: Event not active
- `u107`: Invalid capacity

## 🤝 Contributing

We welcome contributions in:
- New community categories
- Event types and formats
- Help request categories
- Volunteer opportunity templates
- Mentorship program structures
- Social features
- Reputation algorithms

## 📄 License

MIT License - Built for community empowerment

## 🌐 Community Values

**Inclusivity**: Everyone welcome, regardless of background  
**Transparency**: All activities on-chain and verifiable  
**Reciprocity**: Help others, get help when needed  
**Growth**: Continuous learning and development  
**Impact**: Measurable positive community change  

---

**Building stronger communities, one connection at a time 🤝**
