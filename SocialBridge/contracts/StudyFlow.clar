;; SocialBridge - Decentralized Community Connection Platform
;; A comprehensive blockchain-based social platform that tracks community engagement,
;; rewards meaningful connections, and builds inclusive communities

;; Contract constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))
(define-constant err-unauthorized (err u103))
(define-constant err-invalid-input (err u104))
(define-constant err-insufficient-tokens (err u105))
(define-constant err-event-not-active (err u106))
(define-constant err-invalid-capacity (err u107))

;; Token constants
(define-constant token-name "SocialBridge Connection Token")
(define-constant token-symbol "SCT")
(define-constant token-decimals u6)
(define-constant token-max-supply u1000000000000) ;; 1 million tokens with 6 decimals

;; Reward amounts (in micro-tokens)
(define-constant reward-event-hosting u90000000) ;; 90 SCT
(define-constant reward-event-attendance u35000000) ;; 35 SCT
(define-constant reward-community-help u50000000) ;; 50 SCT
(define-constant reward-volunteer-work u75000000) ;; 75 SCT
(define-constant reward-mentorship u85000000) ;; 85 SCT

;; Data variables
(define-data-var total-supply uint u0)
(define-data-var next-member-id uint u1)
(define-data-var next-event-id uint u1)
(define-data-var next-help-id uint u1)

;; Token balances
(define-map token-balances principal uint)

;; Community categories
(define-map community-categories
  uint
  {
    category-name: (string-ascii 64),
    focus-area: (string-ascii 32), ;; "social", "professional", "hobby", "support"
    activity-level: uint, ;; 1-5
    inclusivity-score: uint, ;; 1-10
    growth-potential: uint, ;; 1-5
    verified: bool
  }
)

;; Member profiles
(define-map member-profiles
  principal
  {
    username: (string-ascii 32),
    social-style: (string-ascii 16), ;; "extrovert", "introvert", "ambivert"
    interests: (string-ascii 200),
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
)

;; Community events
(define-map community-events
  uint
  {
    organizer: principal,
    category-id: uint,
    event-title: (string-ascii 128),
    event-description: (string-ascii 500),
    event-type: (string-ascii 32), ;; "meetup", "workshop", "volunteer", "social"
    max-attendees: uint,
    current-attendees: uint,
    event-date: uint,
    duration-hours: uint,
    location: (string-ascii 100),
    entry-fee: uint,
    skill-level: uint, ;; 1-5
    active: bool
  }
)

;; Event attendance
(define-map event-attendance
  { event-id: uint, attendee: principal }
  {
    registration-date: uint,
    attendance-confirmed: bool,
    engagement-level: uint, ;; 1-10
    feedback-rating: uint, ;; 1-5
    feedback-text: (string-ascii 300),
    networking-connections: uint
  }
)

;; Help requests
(define-map help-requests
  uint
  {
    requester: principal,
    category-id: uint,
    help-title: (string-ascii 128),
    help-description: (string-ascii 400),
    urgency-level: uint, ;; 1-5
    skill-required: (string-ascii 64),
    time-commitment: uint, ;; hours
    help-type: (string-ascii 32), ;; "advice", "task", "skill", "emotional"
    location-preference: (string-ascii 64),
    helper: (optional principal),
    request-date: uint,
    completion-date: (optional uint),
    status: (string-ascii 16), ;; "open", "in-progress", "completed"
    resolved: bool
  }
)

;; Volunteer opportunities
(define-map volunteer-opportunities
  uint
  {
    organizer: principal,
    opportunity-title: (string-ascii 128),
    cause-description: (string-ascii 400),
    volunteer-type: (string-ascii 32), ;; "cleanup", "teaching", "support", "fundraising"
    skills-needed: (string-ascii 200),
    time-commitment: uint, ;; hours
    location: (string-ascii 100),
    start-date: uint,
    end-date: uint,
    volunteers-needed: uint,
    current-volunteers: uint,
    impact-area: (string-ascii 64),
    active: bool
  }
)

;; Mentorship programs
(define-map mentorship-programs
  uint
  {
    mentor: principal,
    program-title: (string-ascii 128),
    expertise-area: (string-ascii 64),
    program-description: (string-ascii 400),
    target-audience: (string-ascii 100),
    session-frequency: (string-ascii 16), ;; "weekly", "biweekly", "monthly"
    max-mentees: uint,
    current-mentees: uint,
    program-duration: uint, ;; weeks
    application-fee: uint,
    created-date: uint,
    active: bool
  }
)

;; Social connections
(define-map social-connections
  { member-a: principal, member-b: principal }
  {
    connection-type: (string-ascii 16), ;; "friend", "colleague", "mentor", "mentee"
    connection-date: uint,
    interaction-frequency: uint, ;; 1-10
    mutual-interests: (string-ascii 200),
    connection-strength: uint, ;; 1-10
    last-interaction: uint
  }
)

;; Community feedback
(define-map community-feedback
  uint
  {
    member: principal,
    feedback-type: (string-ascii 16), ;; "suggestion", "complaint", "praise"
    subject: (string-ascii 128),
    feedback-content: (string-ascii 600),
    priority-level: uint, ;; 1-5
    category-id: (optional uint),
    submission-date: uint,
    status: (string-ascii 16), ;; "pending", "reviewed", "resolved"
    admin-response: (string-ascii 400)
  }
)

;; Helper function to get or create member profile
(define-private (get-or-create-profile (member principal))
  (match (map-get? member-profiles member)
    profile profile
    {
      username: "",
      social-style: "ambivert",
      interests: "",
      events-hosted: u0,
      events-attended: u0,
      help-requests-made: u0,
      help-provided: u0,
      volunteer-hours: u0,
      mentoring-sessions: u0,
      reputation-score: u100,
      join-date: stacks-block-height,
      last-activity: stacks-block-height
    }
  )
)

;; Token functions
(define-read-only (get-name)
  (ok token-name)
)

(define-read-only (get-symbol)
  (ok token-symbol)
)

(define-read-only (get-decimals)
  (ok token-decimals)
)

(define-read-only (get-balance (user principal))
  (ok (default-to u0 (map-get? token-balances user)))
)

(define-read-only (get-total-supply)
  (ok (var-get total-supply))
)

(define-private (mint-tokens (recipient principal) (amount uint))
  (let (
    (current-balance (default-to u0 (map-get? token-balances recipient)))
    (new-balance (+ current-balance amount))
    (new-total-supply (+ (var-get total-supply) amount))
  )
    (asserts! (<= new-total-supply token-max-supply) err-invalid-input)
    (map-set token-balances recipient new-balance)
    (var-set total-supply new-total-supply)
    (ok amount)
  )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (let (
    (sender-balance (default-to u0 (map-get? token-balances sender)))
  )
    (asserts! (is-eq tx-sender sender) err-unauthorized)
    (asserts! (>= sender-balance amount) err-insufficient-tokens)
    (try! (mint-tokens recipient amount))
    (map-set token-balances sender (- sender-balance amount))
    (print {action: "transfer", sender: sender, recipient: recipient, amount: amount, memo: memo})
    (ok true)
  )
)

;; Community category management
(define-public (add-community-category (category-name (string-ascii 64)) (focus-area (string-ascii 32))
                                      (activity-level uint) (inclusivity-score uint) (growth-potential uint))
  (let (
    (category-id (var-get next-member-id))
  )
    (asserts! (> (len category-name) u0) err-invalid-input)
    (asserts! (> (len focus-area) u0) err-invalid-input)
    (asserts! (and (>= activity-level u1) (<= activity-level u5)) err-invalid-input)
    (asserts! (and (>= inclusivity-score u1) (<= inclusivity-score u10)) err-invalid-input)
    (asserts! (and (>= growth-potential u1) (<= growth-potential u5)) err-invalid-input)
    
    (map-set community-categories category-id {
      category-name: category-name,
      focus-area: focus-area,
      activity-level: activity-level,
      inclusivity-score: inclusivity-score,
      growth-potential: growth-potential,
      verified: false
    })
    
    (var-set next-member-id (+ category-id u1))
    (print {action: "community-category-added", category-id: category-id, category-name: category-name})
    (ok category-id)
  )
)

;; Event creation
(define-public (create-community-event (category-id uint) (event-title (string-ascii 128))
                                      (event-description (string-ascii 500)) (event-type (string-ascii 32))
                                      (max-attendees uint) (duration-hours uint) (location (string-ascii 100))
                                      (entry-fee uint) (skill-level uint))
  (let (
    (event-id (var-get next-event-id))
    (category (unwrap! (map-get? community-categories category-id) err-not-found))
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len event-title) u0) err-invalid-input)
    (asserts! (> (len event-description) u0) err-invalid-input)
    (asserts! (> (len event-type) u0) err-invalid-input)
    (asserts! (> max-attendees u0) err-invalid-input)
    (asserts! (> duration-hours u0) err-invalid-input)
    (asserts! (and (>= skill-level u1) (<= skill-level u5)) err-invalid-input)
    
    (map-set community-events event-id {
      organizer: tx-sender,
      category-id: category-id,
      event-title: event-title,
      event-description: event-description,
      event-type: event-type,
      max-attendees: max-attendees,
      current-attendees: u0,
      event-date: (+ stacks-block-height u1440), ;; Future date
      duration-hours: duration-hours,
      location: location,
      entry-fee: entry-fee,
      skill-level: skill-level,
      active: true
    })
    
    ;; Update organizer profile
    (map-set member-profiles tx-sender
      (merge profile {
        events-hosted: (+ (get events-hosted profile) u1),
        reputation-score: (+ (get reputation-score profile) u20),
        last-activity: stacks-block-height
      })
    )
    
    ;; Award event hosting reward
    (try! (mint-tokens tx-sender reward-event-hosting))
    
    (var-set next-event-id (+ event-id u1))
    (print {action: "community-event-created", event-id: event-id, organizer: tx-sender, event-title: event-title})
    (ok event-id)
  )
)

;; Event attendance
(define-public (attend-event (event-id uint))
  (let (
    (event (unwrap! (map-get? community-events event-id) err-not-found))
    (attendee-balance (default-to u0 (map-get? token-balances tx-sender)))
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (get active event) err-event-not-active)
    (asserts! (< (get current-attendees event) (get max-attendees event)) err-invalid-capacity)
    (asserts! (>= attendee-balance (get entry-fee event)) err-insufficient-tokens)
    (asserts! (not (is-eq tx-sender (get organizer event))) err-unauthorized)
    (asserts! (is-none (map-get? event-attendance {event-id: event-id, attendee: tx-sender})) err-already-exists)
    
    ;; Pay entry fee if required
    (if (> (get entry-fee event) u0)
      (begin
        (map-set token-balances tx-sender (- attendee-balance (get entry-fee event)))
        (map-set token-balances (get organizer event)
                 (+ (default-to u0 (map-get? token-balances (get organizer event))) (get entry-fee event)))
        true
      )
      true
    )
    
    ;; Register attendance
    (map-set event-attendance {event-id: event-id, attendee: tx-sender} {
      registration-date: stacks-block-height,
      attendance-confirmed: false,
      engagement-level: u0,
      feedback-rating: u0,
      feedback-text: "",
      networking-connections: u0
    })
    
    ;; Update event attendance count
    (map-set community-events event-id
      (merge event {current-attendees: (+ (get current-attendees event) u1)})
    )
    
    ;; Update attendee profile
    (map-set member-profiles tx-sender
      (merge profile {
        events-attended: (+ (get events-attended profile) u1),
        reputation-score: (+ (get reputation-score profile) u8),
        last-activity: stacks-block-height
      })
    )
    
    ;; Award attendance reward
    (try! (mint-tokens tx-sender reward-event-attendance))
    
    (print {action: "event-attended", event-id: event-id, attendee: tx-sender})
    (ok true)
  )
)

;; Help request creation
(define-public (create-help-request (category-id uint) (help-title (string-ascii 128))
                                   (help-description (string-ascii 400)) (urgency-level uint)
                                   (skill-required (string-ascii 64)) (time-commitment uint)
                                   (help-type (string-ascii 32)) (location-preference (string-ascii 64)))
  (let (
    (help-id (var-get next-help-id))
    (category (unwrap! (map-get? community-categories category-id) err-not-found))
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len help-title) u0) err-invalid-input)
    (asserts! (> (len help-description) u0) err-invalid-input)
    (asserts! (and (>= urgency-level u1) (<= urgency-level u5)) err-invalid-input)
    (asserts! (> time-commitment u0) err-invalid-input)
    (asserts! (> (len help-type) u0) err-invalid-input)
    
    (map-set help-requests help-id {
      requester: tx-sender,
      category-id: category-id,
      help-title: help-title,
      help-description: help-description,
      urgency-level: urgency-level,
      skill-required: skill-required,
      time-commitment: time-commitment,
      help-type: help-type,
      location-preference: location-preference,
      helper: none,
      request-date: stacks-block-height,
      completion-date: none,
      status: "open",
      resolved: false
    })
    
    ;; Update requester profile
    (map-set member-profiles tx-sender
      (merge profile {
        help-requests-made: (+ (get help-requests-made profile) u1),
        last-activity: stacks-block-height
      })
    )
    
    (var-set next-help-id (+ help-id u1))
    (print {action: "help-request-created", help-id: help-id, requester: tx-sender, help-title: help-title})
    (ok help-id)
  )
)

;; Help provision
(define-public (provide-help (help-id uint))
  (let (
    (help-request (unwrap! (map-get? help-requests help-id) err-not-found))
    (helper-profile (get-or-create-profile tx-sender))
    (requester-profile (get-or-create-profile (get requester help-request)))
  )
    (asserts! (is-eq (get status help-request) "open") err-invalid-input)
    (asserts! (not (is-eq tx-sender (get requester help-request))) err-unauthorized)
    (asserts! (>= (get reputation-score helper-profile) u120) err-unauthorized)
    
    ;; Update help request
    (map-set help-requests help-id
      (merge help-request {
        helper: (some tx-sender),
        status: "in-progress"
      })
    )
    
    ;; Update helper profile
    (map-set member-profiles tx-sender
      (merge helper-profile {
        help-provided: (+ (get help-provided helper-profile) u1),
        reputation-score: (+ (get reputation-score helper-profile) u15),
        last-activity: stacks-block-height
      })
    )
    
    ;; Award community help reward
    (try! (mint-tokens tx-sender reward-community-help))
    
    (print {action: "help-provided", help-id: help-id, helper: tx-sender, requester: (get requester help-request)})
    (ok true)
  )
)

;; Volunteer opportunity creation
(define-public (create-volunteer-opportunity (opportunity-title (string-ascii 128)) (cause-description (string-ascii 400))
                                           (volunteer-type (string-ascii 32)) (skills-needed (string-ascii 200))
                                           (time-commitment uint) (location (string-ascii 100))
                                           (volunteers-needed uint) (impact-area (string-ascii 64)))
  (let (
    (opportunity-id (var-get next-event-id)) ;; Reuse counter
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len opportunity-title) u0) err-invalid-input)
    (asserts! (> (len cause-description) u0) err-invalid-input)
    (asserts! (> (len volunteer-type) u0) err-invalid-input)
    (asserts! (> time-commitment u0) err-invalid-input)
    (asserts! (> volunteers-needed u0) err-invalid-input)
    (asserts! (>= (get reputation-score profile) u200) err-unauthorized)
    
    (map-set volunteer-opportunities opportunity-id {
      organizer: tx-sender,
      opportunity-title: opportunity-title,
      cause-description: cause-description,
      volunteer-type: volunteer-type,
      skills-needed: skills-needed,
      time-commitment: time-commitment,
      location: location,
      start-date: (+ stacks-block-height u720),
      end-date: (+ stacks-block-height u2160),
      volunteers-needed: volunteers-needed,
      current-volunteers: u0,
      impact-area: impact-area,
      active: true
    })
    
    ;; Update organizer profile
    (map-set member-profiles tx-sender
      (merge profile {
        reputation-score: (+ (get reputation-score profile) u25),
        last-activity: stacks-block-height
      })
    )
    
    ;; Award volunteer organizing reward
    (try! (mint-tokens tx-sender reward-volunteer-work))
    
    (var-set next-event-id (+ opportunity-id u1))
    (print {action: "volunteer-opportunity-created", opportunity-id: opportunity-id, organizer: tx-sender})
    (ok opportunity-id)
  )
)

;; Mentorship program creation
(define-public (create-mentorship-program (program-title (string-ascii 128)) (expertise-area (string-ascii 64))
                                         (program-description (string-ascii 400)) (target-audience (string-ascii 100))
                                         (session-frequency (string-ascii 16)) (max-mentees uint)
                                         (program-duration uint) (application-fee uint))
  (let (
    (program-id (var-get next-help-id)) ;; Reuse counter
    (mentor-profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len program-title) u0) err-invalid-input)
    (asserts! (> (len expertise-area) u0) err-invalid-input)
    (asserts! (> (len program-description) u0) err-invalid-input)
    (asserts! (> max-mentees u0) err-invalid-input)
    (asserts! (> program-duration u0) err-invalid-input)
    (asserts! (>= (get reputation-score mentor-profile) u300) err-unauthorized)
    
    (map-set mentorship-programs program-id {
      mentor: tx-sender,
      program-title: program-title,
      expertise-area: expertise-area,
      program-description: program-description,
      target-audience: target-audience,
      session-frequency: session-frequency,
      max-mentees: max-mentees,
      current-mentees: u0,
      program-duration: program-duration,
      application-fee: application-fee,
      created-date: stacks-block-height,
      active: true
    })
    
    ;; Update mentor profile
    (map-set member-profiles tx-sender
      (merge mentor-profile {
        mentoring-sessions: (+ (get mentoring-sessions mentor-profile) u1),
        reputation-score: (+ (get reputation-score mentor-profile) u30),
        last-activity: stacks-block-height
      })
    )
    
    ;; Award mentorship reward
    (try! (mint-tokens tx-sender reward-mentorship))
    
    (var-set next-help-id (+ program-id u1))
    (print {action: "mentorship-program-created", program-id: program-id, mentor: tx-sender})
    (ok program-id)
  )
)

;; Social connection creation
(define-public (create-social-connection (member-b principal) (connection-type (string-ascii 16))
                                        (mutual-interests (string-ascii 200)) (connection-strength uint))
  (let (
    (profile-a (get-or-create-profile tx-sender))
    (profile-b (get-or-create-profile member-b))
  )
    (asserts! (not (is-eq tx-sender member-b)) err-invalid-input)
    (asserts! (> (len connection-type) u0) err-invalid-input)
    (asserts! (and (>= connection-strength u1) (<= connection-strength u10)) err-invalid-input)
    (asserts! (is-none (map-get? social-connections {member-a: tx-sender, member-b: member-b})) err-already-exists)
    
    (map-set social-connections {member-a: tx-sender, member-b: member-b} {
      connection-type: connection-type,
      connection-date: stacks-block-height,
      interaction-frequency: u5,
      mutual-interests: mutual-interests,
      connection-strength: connection-strength,
      last-interaction: stacks-block-height
    })
    
    ;; Update profiles
    (map-set member-profiles tx-sender
      (merge profile-a {
        reputation-score: (+ (get reputation-score profile-a) u5),
        last-activity: stacks-block-height
      })
    )
    
    ;; Small reward for social connection
    (try! (mint-tokens tx-sender u20000000)) ;; 20 SCT
    
    (print {action: "social-connection-created", member-a: tx-sender, member-b: member-b, connection-type: connection-type})
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-member-profile (member principal))
  (map-get? member-profiles member)
)

(define-read-only (get-community-category (category-id uint))
  (map-get? community-categories category-id)
)

(define-read-only (get-community-event (event-id uint))
  (map-get? community-events event-id)
)

(define-read-only (get-event-attendance (event-id uint) (attendee principal))
  (map-get? event-attendance {event-id: event-id, attendee: attendee})
)

(define-read-only (get-help-request (help-id uint))
  (map-get? help-requests help-id)
)

(define-read-only (get-volunteer-opportunity (opportunity-id uint))
  (map-get? volunteer-opportunities opportunity-id)
)

(define-read-only (get-mentorship-program (program-id uint))
  (map-get? mentorship-programs program-id)
)

(define-read-only (get-social-connection (member-a principal) (member-b principal))
  (map-get? social-connections {member-a: member-a, member-b: member-b})
)

;; Admin functions
(define-public (verify-community-category (category-id uint))
  (let (
    (category (unwrap! (map-get? community-categories category-id) err-not-found))
  )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set community-categories category-id (merge category {verified: true}))
    (print {action: "community-category-verified", category-id: category-id})
    (ok true)
  )
)

(define-public (update-member-username (new-username (string-ascii 32)))
  (let (
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len new-username) u0) err-invalid-input)
    (map-set member-profiles tx-sender (merge profile {username: new-username}))
    (print {action: "member-username-updated", member: tx-sender, username: new-username})
    (ok true)
  )
)