class_name CatalogMock
extends RefCounted
## Mock data for CatalogService. Same shape a future /api/games endpoint should return.

const CATEGORIES := [
	{ "id": "arcade", "name": "Arcade", "color": "f25f5c" },
	{ "id": "puzzle", "name": "Giải đố", "color": "6c4cf1" },
	{ "id": "education", "name": "Học tập", "color": "22b07d" },
	{ "id": "casual", "name": "Thư giãn", "color": "3a8dff" },
]

const GAMES := [
	{
		"id": "tap_rush",
		"name": "Tap Rush",
		"category_id": "arcade",
		"description": "Chạm thật nhanh vào các mục tiêu trước khi hết giờ. Càng nhanh, điểm càng cao!",
	},
	{
		"id": "block_puzzle",
		"name": "Block Puzzle",
		"category_id": "puzzle",
		"description": "Sắp xếp các khối hình để lấp đầy hàng ngang và dọc. Đơn giản nhưng gây nghiện.",
	},
	{
		"id": "math_sprint",
		"name": "Math Sprint",
		"category_id": "education",
		"description": "Giải các phép tính nhanh trong 60 giây để luyện phản xạ tính nhẩm.",
	},
	{
		"id": "word_hunt",
		"name": "Word Hunt",
		"category_id": "education",
		"description": "Tìm các từ tiếng Anh ẩn trong bảng chữ cái. Mở rộng vốn từ mỗi ngày.",
	},
	{
		"id": "memory_match",
		"name": "Memory Match",
		"category_id": "casual",
		"description": "Lật thẻ và ghép các cặp giống nhau. Rèn luyện trí nhớ một cách nhẹ nhàng.",
	},
	{
		"id": "color_jump",
		"name": "Color Jump",
		"category_id": "arcade",
		"description": "Nhảy qua các bục cùng màu với nhân vật. Sai màu là rơi!",
	},
	{
		"id": "sudoku_mini",
		"name": "Sudoku Mini",
		"category_id": "puzzle",
		"description": "Phiên bản Sudoku 6x6 dành cho những phút giải trí ngắn.",
	},
	{
		"id": "bubble_pop",
		"name": "Bubble Pop",
		"category_id": "casual",
		"description": "Bắn bóng cùng màu để làm vỡ chúng. Thư giãn sau một ngày dài.",
	},
]
