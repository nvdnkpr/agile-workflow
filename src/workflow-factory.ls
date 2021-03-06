require! ['./Workflow', './Step', './Actor', './utils']

create-steps = (wid, wf-def, resource)->
  steps = create-unwired-steps wid, wf-def, resource
  start-step = wire-steps steps, wf-def
  [steps, start-step]

create-unwired-steps = (wid, wf-def, resource)->
  steps = {}
  for step-def in wf-def.steps
    steps[step-def.name] = new Step wid, get-actor!, step-def
  steps

wire-steps = (steps, wf-def)->
  for step-def in wf-def.steps
    step = steps[step-def.name]
    step.set-next steps[step-def.next]
    start-step = step if step-def.is-start
  start-step

get-actor = (resource)-> #下一步变成resource def
  new Actor!

module.exports = 
  create-workflow: (wf-def, resource, engine-callback)->
    wid = 'wf-' + utils.get-uuid!
    [steps, start-step] = create-steps wid, wf-def, resource
    start-condition-context = null # 今后这里应该从wf-def中获得 
    new Workflow wid, wf-def.name, steps, start-step, start-condition-context, engine-callback

