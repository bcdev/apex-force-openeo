#import "onion-def.typ"

#set align(center)
#set page(fill: none, width: auto, height: auto)

#let groups = (
    force: blue,
    EOAP: red,
    openEO-backend: green,
)

#let od = onion-def.onion-diagram(
  radius: 7cm,
  line-width: 2pt,
  groups: groups,
  layers: (
    (
      label: "FORCE",
      group: "force",
      index: 0
    ),
    (
      label: "Docker",
      group: "EOAP",
      index: 0
    ),
    (
      label: "CWL-CLTool",
      group: "EOAP",
      index: 1
    ),
    (
      label: "CWL-Workflow",
      group: "EOAP",
      index: 2
    ),
    (
      label: "openEO CWL integration",
      group: "openEO-backend",
      index: 0
    ),
    (
      label: "openEO process",
      group: "openEO-backend",
      index: 1
    ),
    (
      label: "openEO client",
      group: none,
    ),
  ),
)

#od

#let legend(groups) = {
  let single-box(label, color) = box(
    width: 2in,
    height: 0.7in,
    fill: color,
    inset: 6pt,
    radius: 6pt,
    align(center + horizon)[
      #text(fill: white, weight: "bold", size: 18pt)[#label]
    ],
  )
  let boxes = ()
  for key in groups.keys() {
    boxes.push(single-box(key, groups.at(key)))
  }
  stack(
    dir: ttb,
    spacing: 4pt,
    ..boxes)
}

#legend(groups)
