import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/assignment_model.dart';

class AssignmentProvider with ChangeNotifier {
  final List<AssignmentModel> _assignments = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<AssignmentModel> get assignments => List.unmodifiable(_assignments);

  // ------------------- Load assignments from Firestore -------------------
  Future<void> loadAssignments({String? studentId}) async {
    try {
      Query query = _firestore.collection('assignments');
      if (studentId != null) {
        query = query.where('assignedTo', isEqualTo: studentId);
      }
      final snapshot = await query.get();
      _assignments.clear();
      for (var doc in snapshot.docs) {
        _assignments.add(
          AssignmentModel(
            id: doc.id,
            title: doc['title'] ?? '',
            fileUrl: doc['fileUrl'] ?? '',
            assignedBy: doc['assignedBy'] ?? '',
            assignedTo: doc['assignedTo'] ?? '',
            submitted: doc['submitted'] ?? false,
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading assignments: $e");
    }
  }

  // ------------------- Add assignment -------------------
  Future<void> addAssignment(AssignmentModel assignment) async {
    try {
      final docRef = await _firestore.collection('assignments').add({
        'title': assignment.title,
        'fileUrl': assignment.fileUrl,
        'assignedBy': assignment.assignedBy,
        'assignedTo': assignment.assignedTo,
        'submitted': assignment.submitted,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _assignments.add(AssignmentModel(
        id: docRef.id,
        title: assignment.title,
        fileUrl: assignment.fileUrl,
        assignedBy: assignment.assignedBy,
        assignedTo: assignment.assignedTo,
        submitted: assignment.submitted,
      ));
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding assignment: $e");
    }
  }

  // ------------------- Submit assignment -------------------
  Future<void> submitAssignment(String id) async {
    int index = _assignments.indexWhere((a) => a.id == id);
    if (index != -1) {
      try {
        await _firestore.collection('assignments').doc(id).update({
          'submitted': true,
        });
        _assignments[index] = AssignmentModel(
          id: _assignments[index].id,
          title: _assignments[index].title,
          fileUrl: _assignments[index].fileUrl,
          assignedBy: _assignments[index].assignedBy,
          assignedTo: _assignments[index].assignedTo,
          submitted: true,
        );
        notifyListeners();
      } catch (e) {
        debugPrint("Error submitting assignment: $e");
      }
    }
  }

  // ------------------- Remove assignment -------------------
  Future<void> removeAssignment(String id) async {
    try {
      await _firestore.collection('assignments').doc(id).delete();
      _assignments.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Error removing assignment: $e");
    }
  }
}
