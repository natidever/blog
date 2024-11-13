import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_services.dart';
import 'read_blog.dart';

class PostBlog extends StatefulWidget {
  const PostBlog({super.key});

  @override
  State<PostBlog> createState() => _PostBlogState();
}

class _PostBlogState extends State<PostBlog> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  String? _selectedCategory; // Changed to nullable to show the hint initially

  final List<String> _categories = [
    'Technology',
    'Entertainment',
    'Business',
    'Entrepreneurship',
  ];

  final ApiService _apiService = ApiService();

  Future<void> _postBlog() async {
    if (_titleController.text.isEmpty ||
        _postController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final result = await _apiService.createBlog(
        title: _titleController.text,
        description: _postController.text,
        category: _selectedCategory!,
      );

      // Hide loading indicator
      Navigator.pop(context);

      if (result['success']) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );

        // Clear the form
        _titleController.clear();
        _postController.clear();
        setState(() {
          _selectedCategory = null;
        });
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Hide loading indicator
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to post blog'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _postController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReadBlog()),
                );
              },
              icon: const Icon(
                Icons.library_books_rounded,
                color: Color(0xFF141A3D),
              ),
              label: Text(
                'Read Blogs',
                style: GoogleFonts.roboto(
                  color: const Color(0xFF141A3D),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                backgroundColor: const Color(0xFF141A3D).withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Tell your story,\nthe world will hear.',
                style: GoogleFonts.roboto(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    flex: 3, // Adjusted flex ratio
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFFE6E6E6),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _titleController,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF292929),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your title...',
                          hintStyle: GoogleFonts.roboto(
                            color: const Color(0xFF757575),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2, // Adjusted flex ratio
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFFE6E6E6),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true, // Prevents overflow
                            hint: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                'Category',
                                style: GoogleFonts.roboto(
                                  color: const Color(0xFF757575),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            value: _selectedCategory,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF757575),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            borderRadius: BorderRadius.circular(15),
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: const Color(0xFF292929),
                              fontWeight: FontWeight.w500,
                            ),
                            items: _categories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(
                                  category,
                                  overflow: TextOverflow
                                      .ellipsis, // Handles long text
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedCategory = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE6E6E6),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _postController,
                    maxLines: null,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: const Color(0xFF292929),
                      height: 1.6,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Write your story here...',
                      hintStyle: GoogleFonts.roboto(
                        color: const Color(0xFF757575),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Add post functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(20, 26, 61, 1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                  ),
                  child: GestureDetector(
                    onTap: _postBlog,
                    child: Text(
                      'Post',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
