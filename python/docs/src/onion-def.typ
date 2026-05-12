#import "@preview/cetz:0.3.4": canvas, draw

// Onion diagram template using CeTZ
//
// Features:
// - Concentric layered structure
// - Hue grouping for related layers
// - Independent layers visually distinct
// - Parametrizable overall size and line width
// - Configurable labels and colors
//
// Example usage:
//
// #onion-diagram(
//   radius: 6cm,
//   line-width: 1.5pt,
//   layers: (
//     (
//       label: "Core",
//       group: "platform",
//     ),
//     (
//       label: "Infrastructure",
//       group: "platform",
//     ),
//     (
//       label: "Services",
//       group: "platform",
//     ),
//     (
//       label: "Business Logic",
//       group: "business",
//     ),
//     (
//       label: "UI",
//       group: "business",
//     ),
//     (
//       label: "External APIs",
//       group: none,
//     ),
//   ),
// )

#let onion-diagram(
  radius: 5cm,
  line-width: 1pt,
  label-size: 10pt,
  //font: "Linux Libertine",
  // Group → base hue mapping
  groups: (
    platform: blue,
    business: green,
    security: orange,
    data: purple,
  ),
  // Layer specification
  layers: (),
) = {
  let n = layers.len()

  // Avoid division by zero
  if n == 0 {
    panic("onion-diagram requires at least one layer")
  }

  let step = radius / n

  // Compute layer styling
  let layer-style(i, layer) = {
    let group = layer.at("group", default: none)

    if group == none {
      (
        stroke: (
          paint: gray.darken(20%),
          thickness: line-width,
        ),
        fill: luma(92%),
        text-fill: black,
      )
    } else {
      let base = groups.at(group, default: blue)

      // Related layers share hue but vary in lightness
      let t = layer.index

      let fill = if t == 0 {
          base.lighten(35%)
        } else if t == 1 {
          base.lighten(50%)
        } else {
          base.lighten(65%)
        }

      (
        stroke: (
          paint: base.darken(15%),
          thickness: line-width,
        ),
        fill: fill,
        text-fill: black,
      )
    }
  }

  canvas({
    import draw: *

    // Draw outer → inner
    for i in range(n) {
      let idx = n - i - 1
      let layer = layers.at(idx)

      let r = step * (idx + 1)

      let style = layer-style(idx, layer)

      circle(
        (0, 0),
        radius: r,
        stroke: style.stroke,
        fill: style.fill,
      )

      // Label position:
      // placed at top of each ring
      let label_r = if idx == 0 {
          r / 2
        } else {
          r - step / 2
        }

      content(
        (0, label_r),
        text(
          size: label-size,
          // font: font,
          fill: style.text-fill,
          weight: "bold",
          layer.label,
        ),
      )
    }
  })
}
