Company.delete_all
Job.delete_all
Geek.delete_all
Apply.delete_all

Company.reset_pk_sequence
Job.reset_pk_sequence
Geek.reset_pk_sequence
Apply.reset_pk_sequence

Company.create!([
  { name: 'MoGo',        location: 'New York' },
  { name: 'Wirkkle',     location: 'London' },
  { name: 'Artesis',     location: 'Saint-Petersburg' },
  { name: 'BuildEmpire', location: 'London' }
])

Job.create!([
  { name: 'Sinatra React',        place: 'Remote',    company_id: 1 },
  { name: 'Ruby React',           place: 'Contract',  company_id: 2 },
  { name: 'React',                place: 'Remote',    company_id: 3 },
  { name: 'Node React',           place: 'Permanent', company_id: 1 },
  { name: 'Ruby on Rails',        place: 'Remote',    company_id: 4 },
  { name: 'Node',                 place: 'Permanent', company_id: 4 },
  { name: 'Javascript CSS HTML',  place: 'Permanent', company_id: 4 }
])

Geek.create!([
  { name: 'Mike',   stack: 'Sinatra React', resume: 'Has CV' },
  { name: 'Alex',   stack: 'Ruby React',    resume: 'Has CV' },
  { name: 'Martha', stack: 'Rails',         resume: nil },
  { name: 'Juri',   stack: 'Java',          resume: 'Has CV' },
  { name: 'Andrew', stack: 'PHP',           resume: nil },
  { name: 'Nina',   stack: 'Node',          resume: 'Has CV' },
  { name: 'Bob',    stack: 'Front end',     resume: 'Has CV' },
  { name: 'Kate',   stack: 'PHP',           resume: nil },
  { name: 'Boris',  stack: 'Full stack',    resume: 'Has CV' }
])

Apply.create!([
  { job_id: 1, geek_id: 1, read: true,  invited: true },
  { job_id: 1, geek_id: 2, read: false, invited: false },
  { job_id: 5, geek_id: 5, read: true,  invited: false },
  { job_id: 6, geek_id: 8, read: false, invited: false }
])
