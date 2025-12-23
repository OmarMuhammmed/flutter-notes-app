import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';
import '../widgets/empty_state.dart';
import 'note_editor_screen.dart';

class NotesHomeScreen extends StatefulWidget {
  const NotesHomeScreen({super.key});

  @override
  State<NotesHomeScreen> createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  bool _isLoading = true;
  bool _showFavoritesOnly = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNotes = _notes.where((note) {
        final matchesQuery = note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query);
        final matchesFavorite = !_showFavoritesOnly || note.isFavorite;
        return matchesQuery && matchesFavorite;
      }).toList();
    });
  }

  void _toggleFavoriteFilter() {
    setState(() {
      _showFavoritesOnly = !_showFavoritesOnly;
      _onSearchChanged();
    });
  }

  void _toggleNoteFavorite(Note note) {
    final updatedNote = note.copyWith(isFavorite: !note.isFavorite);
    _addOrUpdateNote(updatedNote);
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesJson = prefs.getString('notes');

    if (notesJson != null) {
      final List<dynamic> decodedList = json.decode(notesJson);
      final List<Note> loadedNotes = decodedList
          .map((item) => Note.fromMap(item))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      setState(() {
        _notes = loadedNotes;
        _isLoading = false;
      });
      _onSearchChanged(); 
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveNotesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _notes.map((note) => note.toMap()).toList(),
    );
    await prefs.setString('notes', encodedData);
  }

  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((note) => note.id == id);
      _onSearchChanged(); 
    });
    _saveNotesToPrefs();
  }

  void _addOrUpdateNote(Note note) {
    setState(() {
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes.removeAt(index);
        _notes.insert(0, note);
      } else {
        _notes.insert(0, note);
      }
      _onSearchChanged(); 
    });
    _saveNotesToPrefs();
  }

  Future<void> _navigateToEditor({Note? note}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(note: note),
      ),
    );

    if (result != null && result is Note) {
      _addOrUpdateNote(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar Area
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Notes',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _toggleFavoriteFilter,
                            icon: Icon(
                              _showFavoritesOnly ? Icons.star_rounded : Icons.star_border_rounded,
                              color: _showFavoritesOnly ? Colors.orangeAccent : Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2C),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Search notes...',
                        hintStyle: TextStyle(color: Colors.white38),
                        prefixIcon: Icon(Icons.search, color: Colors.white38),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Notes List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredNotes.isEmpty
                      ? EmptyState(
                          message: _searchController.text.isNotEmpty
                              ? 'No notes match your search.'
                              : (_showFavoritesOnly 
                                  ? 'No favorite notes yet.\nStar some notes to see them here!'
                                  : 'No notes yet.\nTap the + button to create one!'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _filteredNotes.length,
                          itemBuilder: (context, index) {
                            final note = _filteredNotes[index];
                            return Dismissible(
                              key: Key(note.id),
                              background: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 24),
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) => _deleteNote(note.id),
                              child: NoteCard(
                                note: note,
                                onTap: () => _navigateToEditor(note: note),
                                onFavoriteToggle: () => _toggleNoteFavorite(note),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEditor(),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
