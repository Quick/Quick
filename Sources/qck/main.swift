import Commander

let main = Group {
  $0.command("generate-main", generateMain)
}

main.run()
