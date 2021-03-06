/* Copyright (c) Stanford University, The Regents of the University of
 *               California, and others.
 *
 * All Rights Reserved.
 *
 * See Copyright-SimVascular.txt for additional details.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject
 * to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 * IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 *  \class vtkSVMapInterpolator
 *  \brief This is a filter to map a polydata to a target polydata given
 *  a paramterization of the target polydata is given and on the same base domain
 *  of the source polydata.
 *  \details If we have two polydatas that occupy the same region in space;
 *  say the surface of a sphere, or the same planar domain, but they are triangulated
 *  differently, we can compute where each point of the source polydata lies
 *  in the target polydata using barycentric coordinates. This is useful when
 *  we would like to map a point from one surface to another. If the target
 *  polydata has been parameterized in some based domain, then we can take an arbitrary
 *  representation of the same domain, and using the computed barycentric coordinates,
 *  map it to the target surface. The target polydata and the parameterization of the
 *  target polydata must be the same point set with the same connectivity.
 *
 *  \author Adam Updegrove
 *  \author updega2@gmail.com
 *  \author UC Berkeley
 *  \author shaddenlab.berkeley.edu
 */

#ifndef vtkSVMapInterpolator_h
#define vtkSVMapInterpolator_h

#include "vtkPolyDataAlgorithm.h"
#include "vtkSVFiltersModule.h" // For export

#include "vtkPolyData.h"

#include <complex>
#include <vector>

class VTKSVFILTERS_EXPORT vtkSVMapInterpolator : public vtkPolyDataAlgorithm
{
public:
  static vtkSVMapInterpolator* New();
  //vtkTypeRevisionMacro(vtkSVMapInterpolator, vtkPolyDataAlgorithm);
  void PrintSelf(ostream& os, vtkIndent indent);

  //@{
  /// \brief Number of subdivision of source polydata before mapping to
  /// target
  vtkGetMacro(NumSourceSubdivisions, int);
  vtkSetMacro(NumSourceSubdivisions, int);
  //@}

  //@{
  /// \brief static function to map a source polydata to a target polydata
  /// given the parameterization of the target as well
  static int MapSourceToTarget(vtkPolyData *sourceBaseDomainPd,
                               vtkPolyData *targetBaseDomainPd,
                               vtkPolyData *originalTargetPd,
                               vtkPolyData *sourceOnTargetPd);
  //@}

  // Setup and Check Functions
protected:
  vtkSVMapInterpolator();
  ~vtkSVMapInterpolator();

  // Usual data generation method
  /** \details Three inputs for this filter:
   *  1. The base domain to map to the target.
   *  2. The target domain.
   *  3. The target domain that has been paramterized on the base domain. */
  int RequestData(vtkInformation *vtkNotUsed(request),
		  vtkInformationVector **inputVector,
		  vtkInformationVector *outputVector);

  // Main functions in filter
  int PrepFilter(); // Prep work.
  int RunFilter(); // Run filter operations.

  /** \brief Run at the end of filter to make sure boundaries batch. */
  int MatchBoundaries();

  /** \brief Finds the boundary of the given polydata and fills integery
   *  array with boolean values indicating whether point is boundary or not. */
  int FindBoundary(vtkPolyData *pd, vtkIntArray *isBoundary);

  /** \brief special function to move boundary points to target if needed. */
  int MoveBoundaryPoints();

  /** \brief Retrieves the cloest point on the target boundary.
   *  \param srcPtId the point id corresponding to the point to find the new
   *  location of.
   *  \param targCellId the cell id that srcPtId is closest to on target.
   *  \param returnPt  the new 3D location of the srcPtId. */
  int GetPointOnTargetBoundary(int srcPtId, int targCellId, double returnPt[]);

  /** \brief Gets the number of and ids of boundary points on the cell.
   *  \param targCellId Id of cell to get boundaryPts on.
   *  \param boundaryPts empty list that will contain the list of boundary point ids.
   *  \param vtkIntArray isBoundary The boolean array telling which points are
   *  boundary or not. Must be given! Retrieved with FindBoundary function. */
  int BoundaryPointsOnCell(vtkPolyData *pd, int targCellId, vtkIdList *boundaryPts, vtkIntArray *isBoundary);

  /** \brief Projects a point that is not on the boundary onto the boundary.
   *  \param pt0 first point that is on the boundary.
   *  \param pt1 second point that is on the boundary.
   *  \param projPt point that we would like to project to line made by pt0 and pt1.
   *  \param returnPt 3d location of the new projected point. */
  int GetProjectedPoint(double pt0[], double pt1[], double projPt[], double returnPt[]);

  /** \brief Function to find the two closest points on the target boundary.
   *  \param projPt given 3d location to find closest points to.
   *  \param boundaryPts list of three point ids to get closest two from.
   *  \param ptId0 empty int to contain pt id of first closest point.
   *  \param ptId1 empty int to contain pt id of second closest point. */
  int GetClosestTwoPoints(vtkPolyData *pd, double projPt[], vtkIdList *boundaryPts, int &ptId0, int &ptId1);

private:
  vtkSVMapInterpolator(const vtkSVMapInterpolator&);  // Not implemented.
  void operator=(const vtkSVMapInterpolator&);  // Not implemented.

  vtkPolyData *SourceBaseDomainPd;
  vtkPolyData *TargetPd;
  vtkPolyData *TargetBaseDomainPd;
  vtkPolyData *SourceOnTargetPd;

  vtkIntArray *SourceBoundary;
  vtkIntArray *TargetBoundary;

  int NumSourceSubdivisions;
  int HasBoundary;

};

#endif


