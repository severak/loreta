<Cabbage> bounds(0, 0, 0, 0)
form caption("Loreta v 1") size(400, 500), guiMode("queue"), pluginId("lor1")
keyboard bounds(6, 240, 381, 88)
groupbox bounds(4, 8, 389, 60) channel("groupbox10001") text("Common")
label bounds(16, 38, 80, 16) channel("label10002") text("Modwheel")

combobox bounds(100, 36, 80, 20) channel("modwheel") text("vibrato", "morphing") value(1)
groupbox bounds(2, 70, 391, 82) channel("groupbox10004") text("Layer A")
label bounds(14, 98, 80, 16) channel("label10005") text("Timbre")
combobox bounds(98, 94, 80, 20) channel("a_timbre") text("piano", "el piano (SIN)", "e-bass", "e-organ (SAW)", "distorted", "guitar (SQR)", "organ", "oboe") value(1)
label bounds(182, 97, 80, 16) channel("label10007") text("transpose")
combobox bounds(267, 95, 117, 20) channel("a_transpose") text("no", "octave down", "octave up", "small detune", "more detune") value(1)
label bounds(15, 120, 80, 16) channel("label10009") text("Envelope")
combobox bounds(97, 119, 80, 20) channel("a_envelope") text("piano", "organ", "string", "flute", "slow-flute") value(1)
label bounds(181, 119, 80, 16) channel("label10011") text("filter")
combobox bounds(266, 117, 118, 20) channel("a_filter") value(1) text("none", "static 2k", "static 6k", "static 8k", "dynamic 8k", "dynamic 8k dry", "8k quack")
groupbox bounds(4, 158, 391, 77) channel("groupbox10013") text("Layer B")
label bounds(16, 184, 80, 16) channel("label10014") text("Timbre")
combobox bounds(98, 182, 80, 20) channel("b_timbre") text("piano", "el piano (SIN)", "e-bass", "e-organ (SAW)", "distorted", "guitar (SQR)", "organ", "oboe") value(2)
label bounds(180, 184, 80, 16) channel("label10016") text("transpose")
combobox bounds(266, 183, 118, 20) channel("b_transpose") value(1) text("no", "octave down", "octave up", "small detune", "more detune")
label bounds(16, 208, 80, 16) channel("label123") text("Envelope")
combobox bounds(98, 205, 80, 20) channel("b_envelope") value(1) text("piano", "organ", "string", "flute", "slow-flute")
label bounds(179, 207, 80, 16) channel("label10020") text("filter")
combobox bounds(264, 206, 118, 20) channel("b_filter") text("none", "static 2k", "static 6k", "static 8k", "dynamic 8k", "dynamic 8k dry", "8k quack") value(1)
label bounds(183, 38, 80, 16) channel("label10022") text("ratio A:B")
combobox bounds(268, 37, 115, 20) channel("ab_ratio") text("3:1", "2:1", "1:1", "1:2", "1:3", "A only", "B only") value(3)
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n --displays -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1

giWaves[] init 9

giWaves[1] ftgen 0, 0, 0, 1, "akwf/AKWF_piano_0001.wav", 0, 0, 0
giWaves[2] ftgen 0, 0, 0, 1, "akwf/AKWF_epiano_0014.wav", 0, 0, 0
giWaves[3] ftgen 0, 0, 0, 1, "akwf/AKWF_ebass_0042.wav", 0, 0, 0
giWaves[4] ftgen 0, 0, 0, 1, "akwf/AKWF_eorgan_0033.wav", 0, 0, 0
giWaves[5] ftgen 0, 0, 0, 1, "akwf/AKWF_eguitar_0011.wav", 0, 0, 0
giWaves[6] ftgen 0, 0, 0, 1, "akwf/AKWF_eguitar_0003.wav", 0, 0, 0
giWaves[7] ftgen 0, 0, 0, 1, "akwf/AKWF_eorgan_0114.wav", 0, 0, 0
giWaves[8] ftgen 0, 0, 0, 1, "akwf/AKWF_oboe_0013.wav", 0, 0, 0

giTranspose[] init 6
giTranspose[1] = 1
giTranspose[2] = 0.5
giTranspose[3] = 2
giTranspose[4] = 1.001
giTranspose[5] = 1.01


; TODO ideas:
; - higher notes have shorter release (when string)
; - faster attack on more velocity
; - some random stuff to feel more narural (copy from multitrack studio)
; - some stuff for poor velocity sensitivity
; - custom filter settings

;instrument will be triggered by keyboard widget
instr 1
    kbnd pchbend 0, 100
    kcps = p4 + kbnd
    kvel = p5
    
    ; layer A

    ia_timbre chnget "a_timbre"
    ia_transpose chnget "a_transpose"
    ia_envelope chnget "a_envelope"
    ia_filter chnget "a_filter"
        
    aOutA poscil3 0.3, kcps * giTranspose[ia_transpose], giWaves[ia_timbre]
    
    if ia_envelope == 1 then
        ; piano-like
        kAEnv madsr 0.05, 2, 0, 0.2
        kAEnv = kAEnv * kvel
    elseif ia_envelope == 2 then
        ; organ-like
        kAEnv madsr 0.05, 0.01, 1, 0.05
    elseif ia_envelope == 3 then
        ; string-like
        kAEnv madsr 0.05, 1, 0, 1
        kAEnv = kAEnv * kvel
    elseif ia_envelope == 4 then
        ; flute-like
        kAEnv madsr 0.2, 0.1, 0.8, 0.4
    elseif ia_envelope == 5 then
        ; slow-flute-like
        kAEnv madsr 0.5, 0.4, 0.6, 0.6    
    endif
    
    if ia_filter == 2 then
        aOutA moogladder aOutA, 2000, 0.5
    elseif ia_filter == 3 then
        aOutA moogladder aOutA, 6000, 0.5
    elseif ia_filter == 4 then
        aOutA moogladder aOutA, 8000, 0.5
    elseif ia_filter == 5 then
        aOutA moogladder aOutA, 8000*kAEnv, 0.5
    elseif ia_filter == 6 then
        aOutA moogladder aOutA, 8000*kAEnv, 0
    elseif ia_filter == 7 then
        aOutA moogladder aOutA, 8000*kAEnv, 0.85            
    endif
    
    ; layer B
    
    ib_timbre chnget "b_timbre"
    ib_transpose chnget "b_transpose"
    ib_envelope chnget "b_envelope"
    ib_filter chnget "b_filter"
        
    aOutB poscil3 0.3, kcps * giTranspose[ib_transpose], giWaves[ib_timbre]
    
    if ib_envelope == 1 then
        ; piano-like
        kBEnv madsr 0.05, 2, 0, 0.2
        kBEnv = kBEnv * kvel
    elseif ib_envelope == 2 then
        ; organ-like
        kBEnv madsr 0.05, 0.01, 1, 0.05
    elseif ib_envelope == 3 then
        ; string-like
        kBEnv madsr 0.05, 1, 0, 1
        kBEnv = kBEnv * kvel
    elseif ib_envelope == 4 then
        ; flute-like
        kBEnv madsr 0.2, 0.1, 0.8, 0.4
    elseif ib_envelope == 5 then
        ; slow-flute-like
        kBEnv madsr 0.5, 0.4, 0.6, 0.6    
    endif
    
    if ib_filter == 2 then
        aOutB moogladder aOutB, 2000, 0.5
    elseif ib_filter == 3 then
        aOutB moogladder aOutB, 6000, 0.5
    elseif ib_filter == 4 then
        aOutB moogladder aOutB, 8000, 0.5
    elseif ib_filter == 5 then
        aOutB moogladder aOutB, 8000*kBEnv, 0.5
    elseif ib_filter == 6 then
        aOutB moogladder aOutB, 8000*kBEnv, 0
    elseif ib_filter == 7 then
        aOutB moogladder aOutB, 8000*kBEnv, 0.85            
    endif
    
    
    kab_ratio chnget "ab_ratio"
    if kab_ratio == 1 then
        kAmix = 0.75
        kBmix = 0.25
    elseif kab_ratio == 2 then
        kAmix = 0.6
        kBmix = 0.3
    elseif kab_ratio == 3 then
        kAmix = 0.5
        kBmix = 0.5
    elseif kab_ratio == 4 then
        kAmix = 0.3
        kBmix = 0.6
    elseif kab_ratio == 5 then
        kAmix = 0.25
        kBmix = 0.75
    elseif kab_ratio == 6 then
        kAmix = 1
        kBmix = 0
    elseif kab_ratio == 7 then
        kAmix = 0
        kBmix = 1        
    endif
    
    k_modwheel chnget "modwheel"
    if k_modwheel == 2 then
        koscmix midictrl 1 , 0 , 1
        kAmix = koscmix - 1
        kBmix = koscmix
    endif
    
    amix = (aOutA*kAEnv*kAmix) + (aOutB*kBEnv*kBmix)
    amix clip amix, 0, 0.9
    
    outs amix, amix
endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
</CsScore>
</CsoundSynthesizer>
