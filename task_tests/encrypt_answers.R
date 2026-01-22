library(tidyverse)

password <- read_lines("task_tests/secret.txt")

list.files("task_tests", pattern = "_decrypted.txt", full.names = TRUE) |> 
  walk(function(file){
    output_file <- str_replace(file, "decrypted.txt", "encrypted.bin")
    if(file.access(output_file)+1) {
      file.remove(output_file)
      }
    safer::encrypt_file(infile = file, 
                        key = password, 
                        outfile = output_file)
    })

list.files("task_tests", pattern = "_encrypted.bin", full.names = TRUE) |> 
  walk(function(file){
    output_file <- str_replace(file, "encrypted.bin", "decrypted.txt")
    if(file.access(output_file)+1) {
      file.remove(output_file)  
    }
    safer::decrypt_file(infile = file, 
                        key = password, 
                        outfile = output_file)
  })
