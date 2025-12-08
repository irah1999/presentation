import { NextRequest, NextResponse } from 'next/server';

/**
 * GET /api/v1/ppt/presentation/all
 * Get all presentations with their first slide
 */
export async function GET(request: NextRequest) {
    try {
        // TODO: Implement database query
        // For now, return empty array
        // This will be implemented once Prisma is set up

        return NextResponse.json([]);
    } catch (error: any) {
        console.error('Error fetching presentations:', error);
        return NextResponse.json(
            { error: error.message || 'Failed to fetch presentations' },
            { status: 500 }
        );
    }
}
