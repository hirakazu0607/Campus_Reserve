# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample facilities
facilities_data = [
  { name: "大講義室", description: "300名収容可能な大型講義室。プロジェクター、音響設備完備。", capacity: 300, available: true },
  { name: "中講義室A", description: "100名収容可能な中型講義室。ホワイトボード、プロジェクター完備。", capacity: 100, available: true },
  { name: "中講義室B", description: "100名収容可能な中型講義室。ホワイトボード、プロジェクター完備。", capacity: 100, available: true },
  { name: "小会議室", description: "20名収容可能な会議室。ゼミや打ち合わせに最適。", capacity: 20, available: true },
  { name: "体育館", description: "バスケットコート2面分のスペース。各種スポーツイベントに対応。", capacity: 500, available: true },
  { name: "コンピューター室", description: "50台のPCを備えた実習室。プログラミング授業に最適。", capacity: 50, available: true },
  { name: "音楽室", description: "防音完備の音楽練習室。グランドピアノあり。", capacity: 30, available: true },
  { name: "図書館ホール", description: "静かな環境での勉強会や読書会に最適。", capacity: 80, available: true }
]

facilities_data.each do |facility_data|
  Facility.find_or_create_by!(name: facility_data[:name]) do |facility|
    facility.description = facility_data[:description]
    facility.capacity = facility_data[:capacity]
    facility.available = facility_data[:available]
  end
end

puts "Created #{Facility.count} facilities"

# Create sample reservations
sample_reservations = [
  { 
    facility_name: "大講義室", 
    user_name: "田中太郎", 
    user_email: "tanaka@example.com", 
    start_time: 2.days.from_now.change(hour: 10, min: 0), 
    end_time: 2.days.from_now.change(hour: 12, min: 0), 
    purpose: "入学式の準備会議",
    status: "confirmed"
  },
  { 
    facility_name: "中講義室A", 
    user_name: "佐藤花子", 
    user_email: "sato@example.com", 
    start_time: 1.day.from_now.change(hour: 14, min: 0), 
    end_time: 1.day.from_now.change(hour: 16, min: 0), 
    purpose: "ゼミナール",
    status: "confirmed"
  },
  { 
    facility_name: "体育館", 
    user_name: "鈴木一郎", 
    user_email: "suzuki@example.com", 
    start_time: 3.days.from_now.change(hour: 9, min: 0), 
    end_time: 3.days.from_now.change(hour: 17, min: 0), 
    purpose: "体育祭",
    status: "pending"
  }
]

sample_reservations.each do |reservation_data|
  facility = Facility.find_by(name: reservation_data[:facility_name])
  if facility
    Reservation.create!(
      facility: facility,
      user_name: reservation_data[:user_name],
      user_email: reservation_data[:user_email],
      start_time: reservation_data[:start_time],
      end_time: reservation_data[:end_time],
      purpose: reservation_data[:purpose],
      status: reservation_data[:status]
    )
  end
end

puts "Created #{Reservation.count} reservations"
puts "Seed data loaded successfully!"
