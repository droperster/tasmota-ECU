import webserver
import json

class Button_counter_demo : Driver

  def init()
  end

  def web_sensor()

        # ===== mem2 =====
    var m2 = tasmota.cmd("mem2")
    var v2 = int(m2["Mem2"])
    var h2 = v2 / 3600

    if webserver.has_arg("incr_counter2")
      v2 += 3600
      tasmota.cmd("mem2 " + str(v2))
    end

    if webserver.has_arg("decr_counter2")
      if v2 > 0
        v2 -= 3600
        tasmota.cmd("mem2 " + str(v2))
      end
    end

    # ===== mem3 =====
    var m3 = tasmota.cmd("mem3")
    var v3 = int(m3["Mem3"])
    var h3 = v3 / 3600

    if webserver.has_arg("incr_counter3")
      v3 += 3600
      tasmota.cmd("mem3 " + str(v3))
    end

    if webserver.has_arg("decr_counter3")
      if v3 > 0
        v3 -= 3600
        tasmota.cmd("mem3 " + str(v3))
      end
    end

    if webserver.has_arg("clear6")
      tasmota.cmd("mem6 0")
    end

    # ===== mem4 =====
    var mem4 = tasmota.cmd("mem4")
    var v4 = int(mem4["Mem4"])
    var h4 = int(v4 / 3600)
    var m4 = int((v4 % 3600) / 60)
    var s4 = v4 % 60

    # ===== mem5 =====
    var mem5 = tasmota.cmd("mem5")
    var v5 = int(mem5["Mem5"])
    var h5 = int(v5 / 3600)
    var m5 = int((v5 % 3600) / 60)
    var s5 = v5 % 60

    # ===== mem1 =====
    var mem1 = tasmota.cmd("mem1")
    var v1 = int(mem1["Mem1"])
    var h1 = int(v1 / 60)

    # ===== mem6 =====
    var mem6 = tasmota.cmd("mem6")
    var v6 = int(mem6["Mem6"])
    var h6 = int(v6 / 60)


    # ===== вывод =====
    webserver.content_send(format("{s}Час роботи{m}%iг.{e}", h2))
    webserver.content_send(format("{s}Час простою{m}%iг.{e}", h3))
    webserver.content_send(format("{s}Залишок часу роботи{m}%i:%02i:%02i{e}", h4, m4, s4))
    webserver.content_send(format("{s}Залишок часу простою{m}%i:%02i:%02i{e}", h5, m5, s5))
    webserver.content_send(format("{s}Загальна кількість мотогодин{m}%iг.{e}", h1))
    webserver.content_send(format("{s}Кількість мотогодин від останнього ТО{m}%iг.{e}", h6))


  end

  def web_add_main_button()
    webserver.content_send(
      "<p></p>" +

      # --- mem2 ---
    "<div style='display:flex;gap:5px;align-items:center;'>" +
    "<span>Встановити час роботи  :</span>" +
    "<button style='width:180px;height:40px;font-size:20px;' onclick='la(\"&incr_counter2=1\");'>+1г.</button>" +
    "<button style='width:180px;height:40px;font-size:20px;' onclick='la(\"&decr_counter2=1\");'>−1г.</button>" +
    "</div>"+
      
      # --- mem3 ---
    "<div style='display:flex;gap:5px;align-items:center;'>" +
    "<span>Встановити час простою:</span>" +
    "<button style='width:180px;height:40px;font-size:20px;' onclick='la(\"&incr_counter3=1\");'>+1г.</button>" +
    "<button style='width:180px;height:40px;font-size:20px;' onclick='la(\"&decr_counter3=1\");'>−1г.</button>" +
    "</div>"+

      # --- mem6 ---
    "<div style='display:flex;gap:5px;align-items:center;'>" +
    "<span>Очистити мотогодини по ТО</span>" +
    "<button style='width:180px;height:40px;font-size:20px;' onclick='la(\"&clear6=1\");'>0г.</button>" +
    "</div>"
    

    )
  end

end

def sync_timer()
  

    var data = tasmota.cmd("RuleTimer")

    # теперь data — уже map
    tasmota.cmd("Mem4 " + str(data["T2"]))
   
    tasmota.cmd("Mem5 " + str(data["T3"]))
  tasmota.set_timer(60000,sync_timer)
end

tasmota.set_timer(20000,sync_timer)
counter_demo_instance = Button_counter_demo()
tasmota.add_driver(counter_demo_instance)
