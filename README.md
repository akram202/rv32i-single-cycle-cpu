# Cœur RV32I monocycle simplifié
<img width="2432" height="1744" alt="Gemini_Generated_Image_rm6881rm6881rm68" src="https://github.com/user-attachments/assets/e2b66209-4a41-45fe-9869-b1ca133beb2c" />


Cette version n'utilise ni `enum`, ni `struct`, ni package. Les commandes sont de simples vecteurs logiques et les signaux de contrôle sont des ports distincts.

## Compilation et simulation avec Icarus Verilog

Lancer depuis le dossier contenant les fichiers :

```sh
iverilog -g2012 -s tb_rv32i -o simv \
  pc_reg.sv pc_adder.sv register_file.sv imm_decoder.sv \
  alu.sv alu_decoder.sv control_unit.sv inst_mem.sv data_mem.sv \
  rv32i_top.sv tb_rv32i.sv
vvp simv
```

Résultat attendu : `PASS: ADD, SW, LW, BEQ et JAL vérifiés.` Le programme de `program.hex` initialise x1=5 et x2=7, calcule x3=12, stocke puis relit cette valeur, teste BEQ, et valide JAL ainsi que l'adresse de retour.

## Codes de contrôle

- `alu_op`: `00` = addition (adresses et ADDI), `01` = soustraction (BEQ), `10` = décodage R-type.
- `alu_control`: `0000` = ADD, `0001` = SUB, `0010` = AND, `0011` = OR, `0100` = SLT.
- `result_src`: `00` = résultat ALU, `01` = donnée lue en mémoire, `10` = PC+4 (adresse de retour de JAL).
- `pc_src = jump | (branch & zero)` choisit entre PC+immédiat et PC+4.

## Fichiers

- `pc_reg.sv`: registre PC avec reset asynchrone actif à 1.
- `pc_adder.sv`: calcul de PC+4 et PC+immédiat.
- `register_file.sv`: 32 registres, deux lectures combinatoires, écriture synchrone; x0 est câblé à zéro.
- `imm_decoder.sv`: immédiats signés I, S, B et J.
- `alu.sv`, `alu_decoder.sv`: opérations arithmétiques/logiques et génération du signal Zero.
- `control_unit.sv`: décode les opcodes du sous-ensemble.
- `inst_mem.sv`, `data_mem.sv`: mémoires à mots 32 bits.
- `rv32i_top.sv`: interconnexion du datapath.
- `program.hex`, `tb_rv32i.sv`: programme et testbench.

`ResultSrc` utilise 2 bits pour prendre en charge l'écriture de PC+4 par JAL. L'IMEM et la DMEM utilisent des adresses en octets alignées sur 4 octets. Le testbench accède aux registres internes pour vérifier les résultats; ces références ne font pas partie du matériel synthétisé.


 example :
<img width="2400" height="1792" alt="Gemini_Generated_Image_8a4f7q8a4f7q8a4f" src="https://github.com/user-attachments/assets/e4eccf0e-83b9-479a-b7da-7d9fba1b88a7" />





- les resultat final :
- <img width="1914" height="723" alt="Screenshot_20261103_092624-1" src="https://github.com/user-attachments/assets/d51d0e14-45f2-467c-8a9d-3067623a0ea4" />
- <img width="1848" height="606" alt="Screenshot_20261103_095143" src="https://github.com/user-attachments/assets/03a2baab-a52b-44e3-9b6f-ba44b8856970" />



